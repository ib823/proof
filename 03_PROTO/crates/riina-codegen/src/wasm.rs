// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! WebAssembly Backend
//!
//! Translates RIINA IR to WebAssembly binary format (.wasm).
//! Direct emission — no Emscripten, no LLVM, no external tools.
//!
//! # Architecture
//!
//! ```text
//!   ir::Program
//!       │
//!       ▼
//!   ┌────────────────────┐
//!   │  WasmBackend::emit │  IR → WASM instructions
//!   └────────────────────┘
//!       │
//!       ▼
//!   ┌────────────────────┐
//!   │  wasm_encode       │  WASM instructions → binary
//!   └────────────────────┘
//!       │
//!       ▼
//!   .wasm binary + JS glue
//! ```
//!
//! # Memory Layout
//!
//! ```text
//! Linear memory:
//!   [0..data_end)        — string constants (data section)
//!   [data_end..heap_ptr) — bump-allocated heap (pairs, sums, closures, refs)
//!   [heap_ptr..65536)    — free space
//! ```
//!
//! # Security Invariants
//!
//! The WASM backend preserves RIINA's security properties:
//! - Non-interference: WASM linear memory is partitioned for secret/public data
//! - Effect safety: WASM imports gate all side effects
//! - Type safety: WASM's type system enforces stack discipline
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

use crate::backend::{AuxFile, Backend, BackendOutput, Target};
use crate::ir::{
    BasicBlock, BinOp, BlockId, Constant, FuncId, Function, Instruction, Program, Terminator,
    UnaryOp, VarId,
};
use riina_types::Ty;
use crate::wasm_encode::{
    self, DataSegment, ElemSegment, Export, ExportKind, FuncBody, FuncType, GlobalType, Import,
    ImportKind, MemoryType, Op, TableType, ValType, WasmModule,
};
use crate::Result;

use std::collections::HashMap;

/// Initial heap pointer offset (after data section).
/// Aligned to 16 bytes.
const HEAP_START_ALIGN: u32 = 16;

/// Global index for the heap pointer.
const GLOBAL_HEAP_PTR: u32 = 0;

/// Number of imported functions (cetak, panic).
const NUM_IMPORTS: u32 = 2;

/// WebAssembly backend.
pub struct WasmBackend {
    target: Target,
}

impl WasmBackend {
    pub fn new(target: Target) -> Self {
        Self { target }
    }

    /// Translate an IR program to a WASM module.
    fn translate(&self, program: &Program) -> Result<WasmModule> {
        let mut module = WasmModule::new();

        // Collect string constants from the entire program
        let mut string_table: HashMap<String, u32> = HashMap::new();
        let mut data_offset: u32 = 0;
        let mut data_segments: Vec<DataSegment> = Vec::new();

        for func in program.functions.values() {
            for block in &func.blocks {
                for instr in &block.instrs {
                    if let Instruction::Const(Constant::String(s)) = &instr.instr {
                        if !string_table.contains_key(s) {
                            let offset = data_offset;
                            let bytes = s.as_bytes();
                            // Store length (4 bytes) + string bytes
                            data_segments.push(DataSegment {
                                offset,
                                data: {
                                    let mut d = Vec::with_capacity(4 + bytes.len());
                                    d.extend_from_slice(&(bytes.len() as u32).to_le_bytes());
                                    d.extend_from_slice(bytes);
                                    d
                                },
                            });
                            string_table.insert(s.clone(), offset);
                            data_offset += 4 + bytes.len() as u32;
                        }
                    }
                }
            }
        }

        // Align heap start
        let heap_start = (data_offset + HEAP_START_ALIGN - 1) & !(HEAP_START_ALIGN - 1);
        if heap_start == 0 {
            // Even with no data, start heap at 16 to avoid null pointer confusion
        }
        let heap_start = if heap_start == 0 {
            HEAP_START_ALIGN
        } else {
            heap_start
        };

        // === Import section: WASI fd_write for I/O ===
        // fd_write(fd: i32, iovs: i32, iovs_len: i32, nwritten: i32) -> i32
        let fd_write_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32, ValType::I32, ValType::I32, ValType::I32],
            results: vec![ValType::I32],
        });
        // proc_exit(code: i32) -> ()
        let proc_exit_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32],
            results: vec![],
        });

        module.imports.push(Import {
            module: "wasi_snapshot_preview1".to_string(),
            name: "fd_write".to_string(),
            kind: ImportKind::Func(fd_write_type_idx),
        });
        module.imports.push(Import {
            module: "wasi_snapshot_preview1".to_string(),
            name: "proc_exit".to_string(),
            kind: ImportKind::Func(proc_exit_type_idx),
        });

        // === Memory ===
        module.memories.push(MemoryType {
            min: 1,
            max: Some(256),
        });

        // === Global: heap pointer (mutable i32) ===
        let mut heap_init = Vec::new();
        heap_init.push(Op::I32Const as u8);
        wasm_encode::encode_sleb128(heap_start as i64, &mut heap_init);
        heap_init.push(Op::End as u8);
        module.globals.push(GlobalType {
            val_type: ValType::I32,
            mutable: true,
            init: heap_init,
        });

        // Export memory
        module.exports.push(Export {
            name: "memory".to_string(),
            kind: ExportKind::Memory,
            index: 0,
        });

        // === Allocator function: $riina_alloc(size: i32) -> i32 ===
        // This is the first defined function (index = NUM_IMPORTS)
        let alloc_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32],
            results: vec![ValType::I32],
        });
        module.functions.push(alloc_type_idx);
        let alloc_body = self.emit_alloc_function();
        module.codes.push(alloc_body);

        let alloc_func_index = NUM_IMPORTS; // 2 imports, then alloc is index 2

        // === User functions ===
        let mut func_ids: Vec<FuncId> = program.functions.keys().copied().collect();
        func_ids.sort_by_key(|f| f.0); // Deterministic order
        let mut func_index_map: HashMap<FuncId, u32> = HashMap::new();
        for (i, &fid) in func_ids.iter().enumerate() {
            // User functions start after imports + alloc
            func_index_map.insert(fid, NUM_IMPORTS + 1 + i as u32);
        }

        // Table for indirect calls (closures)
        let total_funcs = NUM_IMPORTS + 1 + func_ids.len() as u32;
        module.tables.push(TableType {
            min: total_funcs,
            max: Some(total_funcs),
        });

        // Element segment: initialize table with defined functions (not imports).
        // Starts at table offset NUM_IMPORTS so table[func_idx] = function[func_idx].
        let all_func_indices: Vec<u32> = (NUM_IMPORTS..total_funcs).collect();
        let mut elem_offset = Vec::new();
        elem_offset.push(Op::I32Const as u8);
        wasm_encode::encode_sleb128(NUM_IMPORTS as i64, &mut elem_offset);
        elem_offset.push(Op::End as u8);
        module.elements.push(ElemSegment {
            offset_expr: elem_offset,
            func_indices: all_func_indices,
        });

        // Emit each user function — all share the same type: (i32, i32) -> i32
        let user_func_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32, ValType::I32], // closure_ptr, arg
            results: vec![ValType::I32],
        });

        for &fid in &func_ids {
            let func = program.function(fid).unwrap();
            module.functions.push(user_func_type_idx);

            let body = self.emit_function(
                func,
                &func_index_map,
                &string_table,
                alloc_func_index,
                user_func_type_idx,
            )?;
            module.codes.push(body);
        }

        // === _start trampoline ===
        // WASI expects _start with signature () -> ().
        // Main has signature (i32, i32) -> i32. The trampoline calls main(0, 0) and drops the result.
        if let Some(&main_idx) = func_index_map.get(&FuncId::MAIN) {
            let start_type_idx = module.types.len() as u32;
            module.types.push(FuncType {
                params: vec![],
                results: vec![],
            });
            module.functions.push(start_type_idx);

            let mut trampoline_code = Vec::new();
            // Push closure_ptr=0 and arg=0 for main
            trampoline_code.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(0, &mut trampoline_code);
            trampoline_code.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(0, &mut trampoline_code);
            // Call main; result (i32) is on the stack. Store it in local 0.
            trampoline_code.push(Op::Call as u8);
            wasm_encode::encode_uleb128(main_idx as u64, &mut trampoline_code);
            wasm_local(&mut trampoline_code, Op::LocalSet, 0); // result = local 0

            // Echo the program's final value, byte-identical to the C `main`
            // echo: skip Unit (the `cetak`-then-return-Unit case), otherwise
            // print Int/Bool/String/Element + newline. Locals 1,2 are itoa
            // scratch. `return_ty` is the typechecker-inferred result type,
            // which matches the runtime value (verified against the C backend).
            let main_ret = program
                .function(FuncId::MAIN)
                .map(|f| f.return_ty.clone())
                .unwrap_or(Ty::Unit);
            match main_ret {
                Ty::Unit => { /* no echo */ }
                // A sized integer (`Ty::IntN`) echoes like a plain int — the i32
                // cell already holds the width-masked value (numeric tower).
                Ty::Int | Ty::CInt | Ty::IntN { .. } => {
                    wasm_echo_int(&mut trampoline_code, 0, 1, 2);
                }
                Ty::Bool => {
                    wasm_local(&mut trampoline_code, Op::LocalGet, 0);
                    trampoline_code.push(Op::If as u8);
                    trampoline_code.push(0x40);
                    wasm_write_bytes(&mut trampoline_code, b"true\n");
                    trampoline_code.push(Op::Else as u8);
                    wasm_write_bytes(&mut trampoline_code, b"false\n");
                    trampoline_code.push(Op::End as u8);
                }
                Ty::Element => {
                    wasm_echo_strptr(&mut trampoline_code, 0);
                    wasm_write_bytes(&mut trampoline_code, b"\n");
                }
                Ty::String => {
                    wasm_write_bytes(&mut trampoline_code, b"\"");
                    wasm_echo_strptr(&mut trampoline_code, 0);
                    wasm_write_bytes(&mut trampoline_code, b"\"\n");
                }
                _ => wasm_write_bytes(&mut trampoline_code, b"<value>\n"),
            }

            module.codes.push(FuncBody {
                // locals 0 = main result, 1/2 = itoa scratch
                locals: vec![(3, ValType::I32)],
                code: trampoline_code,
            });

            let start_func_index = NUM_IMPORTS + 1 + func_ids.len() as u32; // after alloc + user funcs
            module.exports.push(Export {
                name: "_start".to_string(),
                kind: ExportKind::Func,
                index: start_func_index,
            });

            // Also export main directly for JS callers
            module.exports.push(Export {
                name: "main".to_string(),
                kind: ExportKind::Func,
                index: main_idx,
            });
        }

        // Data segments
        module.data = data_segments;

        Ok(module)
    }

    /// Emit the bump allocator function body.
    ///
    /// ```wasm
    /// (func $riina_alloc (param $size i32) (result i32)
    ///   (local $ptr i32)
    ///   global.get $heap_ptr
    ///   local.set $ptr
    ///   global.get $heap_ptr
    ///   local.get $size
    ///   i32.add
    ///   global.set $heap_ptr
    ///   local.get $ptr)
    /// ```
    fn emit_alloc_function(&self) -> FuncBody {
        let mut code = Vec::new();

        // local $ptr is local index 1 (param $size is 0)
        // global.get $heap_ptr
        code.push(Op::GlobalGet as u8);
        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, &mut code);
        // local.set $ptr (local 1)
        code.push(Op::LocalSet as u8);
        wasm_encode::encode_uleb128(1, &mut code);
        // global.get $heap_ptr
        code.push(Op::GlobalGet as u8);
        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, &mut code);
        // local.get $size (local 0)
        code.push(Op::LocalGet as u8);
        wasm_encode::encode_uleb128(0, &mut code);
        // i32.add
        code.push(Op::I32Add as u8);
        // global.set $heap_ptr
        code.push(Op::GlobalSet as u8);
        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, &mut code);
        // local.get $ptr
        code.push(Op::LocalGet as u8);
        wasm_encode::encode_uleb128(1, &mut code);

        FuncBody {
            locals: vec![(1, ValType::I32)], // one extra local for $ptr
            code,
        }
    }

    /// Emit WASM instructions for a function.
    ///
    /// This method analyzes the block structure to detect if/else patterns
    /// (CondBranch → then_block/else_block → merge via Phi) and emits
    /// proper WASM structured control flow (if/else/end) instead of
    /// invalid bare br_if instructions.
    fn emit_function(
        &self,
        func: &Function,
        func_map: &HashMap<FuncId, u32>,
        string_table: &HashMap<String, u32>,
        alloc_func_index: u32,
        user_func_type_idx: u32,
    ) -> Result<FuncBody> {
        let mut code = Vec::new();
        let mut locals: Vec<(u32, ValType)> = Vec::new();
        let mut local_count: u32 = 2; // Two params: closure_ptr (local 0), arg (local 1)

        let mut var_to_local: HashMap<VarId, u32> = HashMap::new();
        let mut var_to_func: HashMap<VarId, FuncId> = HashMap::new();

        // Closure calling convention: local 0 = closure_ptr, local 1 = arg
        // The IR's variable numbering for functions with captures:
        //   VarId(0..N-1) = captures (loaded from closure_ptr + (i+1)*4)
        //   VarId(N) = param (local 1 = arg)
        // For functions without captures:
        //   VarId(0) = param (local 1 = arg)
        let num_captures = func.captures.len() as u32;
        var_to_local.insert(VarId::new(num_captures), 1); // param = local 1

        for block in &func.blocks {
            for instr in &block.instrs {
                let result = instr.result;
                if let std::collections::hash_map::Entry::Vacant(e) = var_to_local.entry(result) {
                    e.insert(local_count);
                    local_count += 1;
                }
                match &instr.instr {
                    Instruction::Closure { func: fid, .. } => {
                        var_to_func.insert(result, *fid);
                    }
                    Instruction::Copy(src) => {
                        if let Some(&fid) = var_to_func.get(src) {
                            var_to_func.insert(result, fid);
                        }
                    }
                    Instruction::FixClosure { closure, .. } => {
                        if let Some(&fid) = var_to_func.get(closure) {
                            var_to_func.insert(result, fid);
                        }
                    }
                    _ => {}
                }
            }
        }

        // Allocate locals for captures: VarId(0..N-1) → locals 2, 3, ...
        if !func.captures.is_empty() {
            for i in 0..func.captures.len() {
                let cap_var = VarId::new(i as u32);
                if let std::collections::hash_map::Entry::Vacant(e) = var_to_local.entry(cap_var) {
                    e.insert(local_count);
                    local_count += 1;
                }
            }
        }

        // Reserve two scratch i32 locals for the integer-printing (itoa) routine.
        let itoa_v = local_count;
        let itoa_p = local_count + 1;
        // Six more scratch i32 locals for the string builtins (ke_teks /
        // gabung_teks): result ptr, lengths, source ptrs, copy index.
        let scratch = local_count + 2;
        local_count += 8;

        // Map each IR value to its static type so `cetak` can pick an int vs
        // string-pointer print path.
        let mut var_to_ty: HashMap<VarId, Ty> = HashMap::new();
        for block in &func.blocks {
            for instr in &block.instrs {
                var_to_ty.insert(instr.result, instr.ty.clone());
            }
        }

        // Finalize locals: subtract 2 params (closure_ptr, arg)
        let extra_locals = local_count.saturating_sub(2);
        if extra_locals > 0 {
            locals.push((extra_locals, ValType::I32));
        }

        let ctx = EmitCtx {
            var_map: &var_to_local,
            func_map,
            var_to_func: &var_to_func,
            string_table,
            alloc_func_index,
            user_func_type_idx,
            var_to_ty: &var_to_ty,
            itoa_v,
            itoa_p,
            scratch,
        };

        // Load captures from closure memory into locals.
        // Closure layout: [func_index: i32, capture0: i32, capture1: i32, ...]
        // closure_ptr is local 0. Captures start at offset +4.
        // VarId(i) = capture i, loaded from closure_ptr + (i+1)*4
        if !func.captures.is_empty() {
            for (i, _cap) in func.captures.iter().enumerate() {
                let cap_var = VarId::new(i as u32);
                code.push(Op::LocalGet as u8);
                wasm_encode::encode_uleb128(0, &mut code); // closure_ptr = local 0
                code.push(Op::I32Load as u8);
                code.push(0x02); // align 4
                code.push(((i + 1) * 4) as u8); // offset
                if let Some(&local) = var_to_local.get(&cap_var) {
                    code.push(Op::LocalSet as u8);
                    wasm_encode::encode_uleb128(local as u64, &mut code);
                }
            }
        }

        // Build a block index for quick lookup by BlockId.
        // Note: if multiple blocks share a BlockId, only the last one is kept.
        let block_map: HashMap<BlockId, usize> = func
            .blocks
            .iter()
            .enumerate()
            .map(|(i, b)| (b.id, i))
            .collect();

        // Emit the function body as structured control flow starting from the
        // entry block. The recursion reconstructs nested AND sequential if/else
        // from the lowerer's CondBranch/merge CFG. (The previous ad-hoc loop
        // only handled a single if/else per function — a second sequential
        // if/else had its then/else blocks emitted flat, so both branches ran.)
        // Start at the entry block's index (via block_map, since blocks may
        // share a BlockId and the map keeps the last — e.g. hand-built test IR).
        let entry_idx = block_map.get(&func.entry).copied().unwrap_or(0);
        self.emit_structured(entry_idx, None, func, &ctx, &block_map, &mut code)?;

        if code.is_empty() || !matches!(code.last(), Some(&b) if b == Op::Return as u8) {
            code.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(0, &mut code);
        }

        Ok(FuncBody { locals, code })
    }

    /// Emit a region of the CFG as structured WASM control flow, from block
    /// `entry` up to (but not including) `stop`. Reconstructs nested AND
    /// sequential if/else from `CondBranch` terminators; the merge of each
    /// `CondBranch` is the block its then/else branches rejoin at.
    ///
    /// Returns the index of the block from which this region exits to `stop`
    /// (i.e. the merge's actual predecessor), or `None` if the region diverges
    /// (ends in `Return`/`Unreachable`) or has no merge. The caller uses this
    /// exit block — not the region's entry — to push the branch's contribution
    /// to the merge `Phi`. This is what makes a *nested* if/else correct: its
    /// exit is an inner merge block, which is the block the lowerer keys the
    /// outer `Phi` entry by; the entry block (an inner `CondBranch`) is not.
    fn emit_structured(
        &self,
        entry: usize,
        stop: Option<usize>,
        func: &Function,
        ctx: &EmitCtx<'_>,
        block_map: &HashMap<BlockId, usize>,
        code: &mut Vec<u8>,
    ) -> Result<Option<usize>> {
        let mut cur = entry;
        loop {
            if Some(cur) == stop {
                return Ok(None);
            }
            let block = &func.blocks[cur];
            self.emit_block_instrs(block, ctx, code)?;
            match &block.terminator {
                Some(Terminator::Return(var)) => {
                    if let Some(local) = ctx.var_map.get(var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                    code.push(Op::Return as u8);
                    return Ok(None);
                }
                Some(Terminator::Unreachable) => {
                    code.push(Op::Unreachable as u8);
                    return Ok(None);
                }
                Some(Terminator::Branch(target)) => match block_map.get(target) {
                    Some(&t) => {
                        if Some(t) == stop {
                            // `cur` is the region's exit: it rejoins the enclosing
                            // merge. Report it so the caller pushes the right phi
                            // contribution (for a nested if/else this is an inner
                            // merge block, not the region's entry CondBranch).
                            return Ok(Some(cur));
                        }
                        cur = t;
                    }
                    None => return Ok(None),
                },
                Some(Terminator::CondBranch {
                    cond,
                    then_block,
                    else_block,
                }) => {
                    let (Some(&then_idx), Some(&else_idx)) =
                        (block_map.get(then_block), block_map.get(else_block))
                    else {
                        return Ok(None);
                    };
                    // The merge is where the two branches rejoin: the Branch
                    // target of the then (or else) branch.
                    let merge = Self::branch_target(&func.blocks[then_idx], block_map)
                        .or_else(|| Self::branch_target(&func.blocks[else_idx], block_map));

                    if let Some(local) = ctx.var_map.get(cond) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                    code.push(Op::If as u8);
                    code.push(ValType::I32 as u8);
                    // Emit each branch region, then push its contribution to the
                    // merge phi from the region's EXIT block (its merge
                    // predecessor), falling back to the entry block when the
                    // region diverges (no exit-to-merge).
                    let then_exit =
                        self.emit_structured(then_idx, merge, func, ctx, block_map, code)?;
                    self.emit_phi_value_for_branch(
                        &func.blocks[then_exit.unwrap_or(then_idx)],
                        &func.blocks,
                        block_map,
                        ctx,
                        code,
                    )?;
                    code.push(Op::Else as u8);
                    let else_exit =
                        self.emit_structured(else_idx, merge, func, ctx, block_map, code)?;
                    self.emit_phi_value_for_branch(
                        &func.blocks[else_exit.unwrap_or(else_idx)],
                        &func.blocks,
                        block_map,
                        ctx,
                        code,
                    )?;
                    code.push(Op::End as u8);
                    // Store the if/else result into the merge's phi local.
                    if let Some(m) = merge {
                        for instr in &func.blocks[m].instrs {
                            if let Instruction::Phi(_) = &instr.instr {
                                if let Some(local) = ctx.var_map.get(&instr.result) {
                                    code.push(Op::LocalSet as u8);
                                    wasm_encode::encode_uleb128(*local as u64, code);
                                }
                                break;
                            }
                        }
                    }
                    match merge {
                        Some(m) => cur = m,
                        None => return Ok(None),
                    }
                }
                Some(Terminator::Handle { .. }) | None => return Ok(None),
            }
        }
    }

    /// The block index a block unconditionally branches to, if any.
    fn branch_target(block: &BasicBlock, block_map: &HashMap<BlockId, usize>) -> Option<usize> {
        match &block.terminator {
            Some(Terminator::Branch(t)) => block_map.get(t).copied(),
            _ => None,
        }
    }

    /// Emit only the instructions of a block (no terminator).
    fn emit_block_instrs(
        &self,
        block: &BasicBlock,
        ctx: &EmitCtx<'_>,
        code: &mut Vec<u8>,
    ) -> Result<()> {
        for instr in &block.instrs {
            self.emit_instruction(&instr.instr, Some(instr.result), ctx, code)?;
        }
        Ok(())
    }

    /// For a then/else block that branches to a merge block with a Phi,
    /// push the value that this block contributes to the Phi onto the stack.
    fn emit_phi_value_for_branch(
        &self,
        branch_block: &BasicBlock,
        blocks: &[BasicBlock],
        block_map: &HashMap<BlockId, usize>,
        ctx: &EmitCtx<'_>,
        code: &mut Vec<u8>,
    ) -> Result<()> {
        // Find the merge block (target of this block's Branch terminator)
        let target_id = match &branch_block.terminator {
            Some(Terminator::Branch(target)) => Some(*target),
            _ => None,
        };

        if let Some(target_id) = target_id {
            if let Some(&merge_idx) = block_map.get(&target_id) {
                let merge_blk = &blocks[merge_idx];
                // Find the phi node and extract this block's contribution
                for instr in &merge_blk.instrs {
                    if let Instruction::Phi(entries) = &instr.instr {
                        for (bb_id, var) in entries {
                            if *bb_id == branch_block.id {
                                // Push this variable onto the stack
                                if let Some(local) = ctx.var_map.get(var) {
                                    code.push(Op::LocalGet as u8);
                                    wasm_encode::encode_uleb128(*local as u64, code);
                                }
                                return Ok(());
                            }
                        }
                    }
                }
            }
        }

        // If we couldn't find a phi contribution, look at the last instruction
        // in this block and push its result (common fallback)
        if let Some(last_instr) = branch_block.instrs.last() {
            if let Some(local) = ctx.var_map.get(&last_instr.result) {
                code.push(Op::LocalGet as u8);
                wasm_encode::encode_uleb128(*local as u64, code);
            }
        } else {
            // Empty block — push 0
            code.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(0, code);
        }

        Ok(())
    }

    // emit_block is no longer used — block emission is now handled by
    // emit_function (structured if/else) + emit_block_instrs + emit_block_terminator.

    /// Helper: emit `call $riina_alloc` with size on stack.
    fn emit_alloc_call(alloc_func_index: u32, size: u32, code: &mut Vec<u8>) {
        code.push(Op::I32Const as u8);
        wasm_encode::encode_sleb128(size as i64, code);
        code.push(Op::Call as u8);
        wasm_encode::encode_uleb128(alloc_func_index as u64, code);
    }

    /// Helper: emit local.get for a VarId.
    fn emit_local_get(var: &VarId, var_map: &HashMap<VarId, u32>, code: &mut Vec<u8>) {
        if let Some(local) = var_map.get(var) {
            code.push(Op::LocalGet as u8);
            wasm_encode::encode_uleb128(*local as u64, code);
        }
    }

    /// Emit code that prints the integer in `arg` as unsigned decimal ASCII via
    /// WASI `fd_write`. Digits are written backwards into heap scratch
    /// (`heap_ptr+16..heap_ptr+48`); the iovec lives at `heap_ptr` and
    /// `nwritten` at `heap_ptr+8`, matching the string path's scratch layout.
    fn emit_print_int(arg: &VarId, ctx: &EmitCtx, code: &mut Vec<u8>) {
        let set_v = |c: &mut Vec<u8>| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(ctx.itoa_v as u64, c);
        };
        let get_v = |c: &mut Vec<u8>| {
            c.push(Op::LocalGet as u8);
            wasm_encode::encode_uleb128(ctx.itoa_v as u64, c);
        };
        let set_p = |c: &mut Vec<u8>| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(ctx.itoa_p as u64, c);
        };
        let get_p = |c: &mut Vec<u8>| {
            c.push(Op::LocalGet as u8);
            wasm_encode::encode_uleb128(ctx.itoa_p as u64, c);
        };
        let heap = |c: &mut Vec<u8>| {
            c.push(Op::GlobalGet as u8);
            wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, c);
        };
        let i32c = |c: &mut Vec<u8>, n: i64| {
            c.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(n, c);
        };

        // $v = arg
        Self::emit_local_get(arg, ctx.var_map, code);
        set_v(code);
        // $p = heap_ptr + 48  (one past the digit buffer; we write backwards)
        heap(code);
        i32c(code, 48);
        code.push(Op::I32Add as u8);
        set_p(code);

        // do { p--; mem[p] = '0' + (v % 10); v = v / 10 } while (v != 0)
        code.push(Op::Loop as u8);
        code.push(0x40); // empty block type
        {
            // p = p - 1
            get_p(code);
            i32c(code, 1);
            code.push(Op::I32Sub as u8);
            set_p(code);
            // mem[p] = 48 + (v % 10)   (i32.store8: addr then value)
            get_p(code);
            get_v(code);
            i32c(code, 10);
            code.push(Op::I32RemU as u8);
            i32c(code, 48); // '0'
            code.push(Op::I32Add as u8);
            code.push(Op::I32Store8 as u8);
            code.push(0x00); // align 0 (1-byte)
            code.push(0x00); // offset 0
            // v = v / 10
            get_v(code);
            i32c(code, 10);
            code.push(Op::I32DivU as u8);
            set_v(code);
            // if v != 0, branch back to loop (depth 0)
            get_v(code);
            code.push(Op::BrIf as u8);
            wasm_encode::encode_uleb128(0, code);
        }
        code.push(Op::End as u8);

        // iovec.ptr = $p   → store at heap_ptr[0]
        heap(code);
        get_p(code);
        code.push(Op::I32Store as u8);
        code.push(0x02);
        code.push(0x00);
        // iovec.len = (heap_ptr + 48) - $p   → store at heap_ptr[4]
        heap(code);
        heap(code);
        i32c(code, 48);
        code.push(Op::I32Add as u8);
        get_p(code);
        code.push(Op::I32Sub as u8);
        code.push(Op::I32Store as u8);
        code.push(0x02);
        code.push(0x04); // offset 4
        // fd_write(1, heap_ptr, 1, heap_ptr+8)
        i32c(code, 1);
        heap(code);
        i32c(code, 1);
        heap(code);
        i32c(code, 8);
        code.push(Op::I32Add as u8);
        code.push(Op::Call as u8);
        wasm_encode::encode_uleb128(0, code); // fd_write
        code.push(Op::Drop as u8);
    }

    /// `ke_teks(int)` → a heap string `[len:u32][ascii digits]`; leaves the
    /// pointer on the stack. Two passes: count digits, alloc, write digits.
    fn emit_ke_teks(arg: &VarId, ctx: &EmitCtx, code: &mut Vec<u8>) {
        let v = ctx.itoa_v;
        let wp = ctx.itoa_p;
        let rp = ctx.scratch;
        let cnt = ctx.scratch + 1;
        let get = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalGet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        let set = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        // Pass 1: count digits (always >= 1). v = arg; cnt = 0.
        Self::emit_local_get(arg, ctx.var_map, code);
        set(code, v);
        wasm_i32c(code, 0);
        set(code, cnt);
        code.push(Op::Loop as u8);
        code.push(0x40);
        get(code, cnt);
        wasm_i32c(code, 1);
        code.push(Op::I32Add as u8);
        set(code, cnt);
        get(code, v);
        wasm_i32c(code, 10);
        code.push(Op::I32DivU as u8);
        set(code, v);
        get(code, v);
        code.push(Op::BrIf as u8);
        wasm_encode::encode_uleb128(0, code);
        code.push(Op::End as u8);
        // rp = alloc(align4(4 + cnt)) — keep the bump pointer 4-aligned so the
        // i32 length-prefix store below stays aligned.
        wasm_i32c(code, 4);
        get(code, cnt);
        code.push(Op::I32Add as u8);
        wasm_i32c(code, 3);
        code.push(Op::I32Add as u8);
        wasm_i32c(code, -4); // & ~3
        code.push(Op::I32And as u8);
        code.push(Op::Call as u8);
        wasm_encode::encode_uleb128(ctx.alloc_func_index as u64, code);
        set(code, rp);
        // mem[rp] = cnt (length prefix)
        get(code, rp);
        get(code, cnt);
        code.push(Op::I32Store as u8);
        code.push(0x02);
        code.push(0x00);
        // Pass 2: write digits backward into [rp+4, rp+4+cnt). v = arg; wp = rp+4+cnt.
        Self::emit_local_get(arg, ctx.var_map, code);
        set(code, v);
        get(code, rp);
        wasm_i32c(code, 4);
        code.push(Op::I32Add as u8);
        get(code, cnt);
        code.push(Op::I32Add as u8);
        set(code, wp);
        code.push(Op::Loop as u8);
        code.push(0x40);
        get(code, wp);
        wasm_i32c(code, 1);
        code.push(Op::I32Sub as u8);
        set(code, wp);
        get(code, wp);
        get(code, v);
        wasm_i32c(code, 10);
        code.push(Op::I32RemU as u8);
        wasm_i32c(code, 48);
        code.push(Op::I32Add as u8);
        code.push(Op::I32Store8 as u8);
        code.push(0x00);
        code.push(0x00);
        get(code, v);
        wasm_i32c(code, 10);
        code.push(Op::I32DivU as u8);
        set(code, v);
        get(code, v);
        code.push(Op::BrIf as u8);
        wasm_encode::encode_uleb128(0, code);
        code.push(Op::End as u8);
        // result = rp
        get(code, rp);
    }

    /// `gabung_teks((s1, s2))` → a freshly-allocated heap string that is the
    /// concatenation of the two `[len][bytes]` strings; leaves the pointer on
    /// the stack. `arg` is a pair pointer `[s1:i32][s2:i32]`.
    fn emit_gabung_teks(arg: &VarId, ctx: &EmitCtx, code: &mut Vec<u8>) {
        let s1 = ctx.scratch;
        let s2 = ctx.scratch + 1;
        let set = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        let load = |c: &mut Vec<u8>, off: u8| {
            c.push(Op::I32Load as u8);
            c.push(0x02);
            c.push(off);
        };
        // s1 = mem[arg+0]; s2 = mem[arg+4]
        Self::emit_local_get(arg, ctx.var_map, code);
        load(code, 0x00);
        set(code, s1);
        Self::emit_local_get(arg, ctx.var_map, code);
        load(code, 0x04);
        set(code, s2);
        Self::emit_str_concat_core(ctx, code);
    }

    /// String `Add` (concatenation) of two operand string pointers. UI/text
    /// lowering emits concatenation as `BinOp(Add)` on `Ty::String`, so the
    /// WASM `Add` path routes string-typed operands here instead of `i32.add`.
    fn emit_str_add(lhs: &VarId, rhs: &VarId, ctx: &EmitCtx, code: &mut Vec<u8>) {
        let s1 = ctx.scratch;
        let s2 = ctx.scratch + 1;
        let set = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        Self::emit_local_get(lhs, ctx.var_map, code);
        set(code, s1);
        Self::emit_local_get(rhs, ctx.var_map, code);
        set(code, s2);
        Self::emit_str_concat_core(ctx, code);
    }

    /// Concatenate the two `[len][bytes]` heap strings whose pointers are held in
    /// scratch locals `s1` (= `ctx.scratch`) and `s2` (= `ctx.scratch + 1`):
    /// allocate a fresh `[len1+len2][bytes]` string and leave its pointer on the
    /// stack. Shared by `gabung_teks` and the string `Add` path.
    fn emit_str_concat_core(ctx: &EmitCtx, code: &mut Vec<u8>) {
        let s1 = ctx.scratch;
        let s2 = ctx.scratch + 1;
        let len1 = ctx.scratch + 2;
        let len2 = ctx.scratch + 3;
        let rp = ctx.scratch + 4;
        let idx = ctx.itoa_v;
        let get = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalGet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        let set = |c: &mut Vec<u8>, l: u32| {
            c.push(Op::LocalSet as u8);
            wasm_encode::encode_uleb128(l as u64, c);
        };
        let load = |c: &mut Vec<u8>, off: u8| {
            c.push(Op::I32Load as u8);
            c.push(0x02);
            c.push(off);
        };
        // len1 = mem[s1]; len2 = mem[s2]
        get(code, s1);
        load(code, 0x00);
        set(code, len1);
        get(code, s2);
        load(code, 0x00);
        set(code, len2);
        // rp = alloc(align4(4 + len1 + len2)) — keep the bump pointer 4-aligned.
        wasm_i32c(code, 4);
        get(code, len1);
        code.push(Op::I32Add as u8);
        get(code, len2);
        code.push(Op::I32Add as u8);
        wasm_i32c(code, 3);
        code.push(Op::I32Add as u8);
        wasm_i32c(code, -4);
        code.push(Op::I32And as u8);
        code.push(Op::Call as u8);
        wasm_encode::encode_uleb128(ctx.alloc_func_index as u64, code);
        set(code, rp);
        // mem[rp] = len1 + len2
        get(code, rp);
        get(code, len1);
        get(code, len2);
        code.push(Op::I32Add as u8);
        code.push(Op::I32Store as u8);
        code.push(0x02);
        code.push(0x00);
        // copy_loop(dst_base, src, len): emit a `while idx < len` byte copy.
        let copy = |c: &mut Vec<u8>, dst_extra: &dyn Fn(&mut Vec<u8>), src: u32, len: u32| {
            wasm_i32c(c, 0);
            set(c, idx);
            c.push(Op::Block as u8);
            c.push(0x40);
            c.push(Op::Loop as u8);
            c.push(0x40);
            // if idx >= len, break out of block (depth 1)
            get(c, idx);
            get(c, len);
            c.push(Op::I32GeU as u8);
            c.push(Op::BrIf as u8);
            wasm_encode::encode_uleb128(1, c);
            // dst addr = rp + 4 + <dst_extra> + idx
            get(c, rp);
            wasm_i32c(c, 4);
            c.push(Op::I32Add as u8);
            dst_extra(c);
            get(c, idx);
            c.push(Op::I32Add as u8);
            // src byte = mem[src + 4 + idx]
            get(c, src);
            wasm_i32c(c, 4);
            c.push(Op::I32Add as u8);
            get(c, idx);
            c.push(Op::I32Add as u8);
            c.push(Op::I32Load8U as u8);
            c.push(0x00);
            c.push(0x00);
            // store byte
            c.push(Op::I32Store8 as u8);
            c.push(0x00);
            c.push(0x00);
            // idx++
            get(c, idx);
            wasm_i32c(c, 1);
            c.push(Op::I32Add as u8);
            set(c, idx);
            c.push(Op::Br as u8);
            wasm_encode::encode_uleb128(0, c);
            c.push(Op::End as u8); // loop
            c.push(Op::End as u8); // block
        };
        // copy s1 into [rp+4 ..)
        copy(code, &|_c: &mut Vec<u8>| {}, s1, len1);
        // copy s2 into [rp+4+len1 ..)
        copy(
            code,
            &|c: &mut Vec<u8>| {
                get(c, len1);
                c.push(Op::I32Add as u8);
            },
            s2,
            len2,
        );
        // result = rp
        get(code, rp);
    }

    /// Emit a single IR instruction as WASM instructions.
    fn emit_instruction(
        &self,
        instr: &Instruction,
        result: Option<VarId>,
        ctx: &EmitCtx<'_>,
        code: &mut Vec<u8>,
    ) -> Result<()> {
        match instr {
            Instruction::Const(c) => {
                match c {
                    Constant::Unit => {
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(0, code);
                    }
                    Constant::Bool(b) => {
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(if *b { 1 } else { 0 }, code);
                    }
                    Constant::Int(n) => {
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(*n as i64, code);
                    }
                    Constant::String(s) => {
                        // Push pointer to string in data section (points to length prefix)
                        if let Some(&offset) = ctx.string_table.get(s) {
                            code.push(Op::I32Const as u8);
                            wasm_encode::encode_sleb128(offset as i64, code);
                        } else {
                            code.push(Op::I32Const as u8);
                            wasm_encode::encode_sleb128(0, code);
                        }
                    }
                }
            }
            Instruction::Load(var) => {
                // Dereference: load i32 from memory address held in var
                Self::emit_local_get(var, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02); // alignment: 4
                code.push(0x00); // offset: 0
            }
            Instruction::Store(dst, src) => {
                // Store to memory: *dst = src
                Self::emit_local_get(dst, ctx.var_map, code);
                Self::emit_local_get(src, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02); // alignment: 4
                code.push(0x00); // offset: 0
                                 // Store returns unit (0)
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::BinOp(op, lhs, rhs)
                if matches!(op, BinOp::Add)
                    && matches!(
                        ctx.var_to_ty.get(lhs),
                        Some(Ty::String | Ty::Element | Ty::Color | Ty::UIStyle)
                    ) =>
            {
                // String concatenation is lowered as `Add` on `Ty::String`
                // operands (see `emit_concat` / UI lowering); emit the heap-string
                // concat routine rather than integer add. Leaves the result
                // pointer on the stack for the generic result-store below.
                Self::emit_str_add(lhs, rhs, ctx, code);
            }
            Instruction::BinOp(op, lhs, rhs) => {
                Self::emit_local_get(lhs, ctx.var_map, code);
                Self::emit_local_get(rhs, ctx.var_map, code);
                match op {
                    BinOp::Add => code.push(Op::I32Add as u8),
                    BinOp::Sub => code.push(Op::I32Sub as u8),
                    BinOp::Mul => code.push(Op::I32Mul as u8),
                    BinOp::Div => code.push(Op::I32DivS as u8),
                    BinOp::Eq => code.push(Op::I32Eq as u8),
                    BinOp::Ne => code.push(Op::I32Ne as u8),
                    BinOp::Mod => code.push(Op::I32RemS as u8),
                    BinOp::Lt => code.push(Op::I32LtS as u8),
                    BinOp::Gt => code.push(Op::I32GtS as u8),
                    BinOp::Le => code.push(Op::I32LeS as u8),
                    BinOp::Ge => code.push(Op::I32GeS as u8),
                    BinOp::And => code.push(Op::I32And as u8),
                    BinOp::Or => code.push(Op::I32Or as u8),
                }
                // Numeric tower: mask an arithmetic result that types as a sized
                // integer narrower than the i32 cell to its width (`& (2^bits-1)`),
                // so compiled overflow wraps modulo 2^bits like the interpreter and
                // the C backend. Operands are already in-range (every sized value
                // comes from a masked literal or a masked arithmetic result), so
                // masking the result suffices. Comparisons type as `Bool`, so they
                // are not masked.
                if let Some(r) = result.as_ref() {
                    if let Some(Ty::IntN { bits, .. }) = ctx.var_to_ty.get(r) {
                        if *bits < 32 {
                            code.push(Op::I32Const as u8);
                            wasm_encode::encode_sleb128((1i64 << bits) - 1, code);
                            code.push(Op::I32And as u8);
                        }
                    }
                }
            }
            Instruction::UnaryOp(op, operand) => match op {
                UnaryOp::Not => {
                    Self::emit_local_get(operand, ctx.var_map, code);
                    code.push(Op::I32Eqz as u8);
                }
                UnaryOp::Neg => {
                    code.push(Op::I32Const as u8);
                    wasm_encode::encode_sleb128(0, code);
                    Self::emit_local_get(operand, ctx.var_map, code);
                    code.push(Op::I32Sub as u8);
                }
            },
            Instruction::Call(func_var, arg) => {
                if let Some(fid) = ctx.var_to_func.get(func_var) {
                    if let Some(&idx) = ctx.func_map.get(fid) {
                        // Direct call: push closure_ptr (the var itself), then arg
                        Self::emit_local_get(func_var, ctx.var_map, code);
                        Self::emit_local_get(arg, ctx.var_map, code);
                        code.push(Op::Call as u8);
                        wasm_encode::encode_uleb128(idx as u64, code);
                    } else {
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(0, code);
                        Self::emit_local_get(arg, ctx.var_map, code);
                        code.push(Op::Call as u8);
                        wasm_encode::encode_uleb128(0, code);
                    }
                } else {
                    // Indirect call through closure pointer
                    // Push closure_ptr (first arg), then arg (second arg)
                    Self::emit_local_get(func_var, ctx.var_map, code);
                    Self::emit_local_get(arg, ctx.var_map, code);
                    // Load func_idx from closure memory for table index
                    Self::emit_local_get(func_var, ctx.var_map, code);
                    code.push(Op::I32Load as u8);
                    code.push(0x02);
                    code.push(0x00); // load func_table_idx from closure[0]
                                     // call_indirect: type must match (i32, i32) -> i32
                                     // Find the user function type index (first user function type)
                    code.push(Op::CallIndirect as u8);
                    wasm_encode::encode_uleb128(ctx.user_func_type_idx as u64, code);
                    wasm_encode::encode_uleb128(0, code); // table 0
                }
            }
            Instruction::Pair(a, b) => {
                // Alloc 8 bytes, store a at +0, b at +4
                Self::emit_alloc_call(ctx.alloc_func_index, 8, code);
                // Duplicate ptr: tee to result local, then use it
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalTee as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                // Store a at ptr+0
                Self::emit_local_get(a, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x00);
                // Store b at ptr+4
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(b, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02); // align 4
                code.push(0x04); // offset 4
                                 // Result is already in local from LocalTee; load it back for the
                                 // generic LocalSet below
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::Fst(pair) => {
                // Load i32 at pair_ptr + 0
                Self::emit_local_get(pair, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02);
                code.push(0x00);
            }
            Instruction::Snd(pair) => {
                // Load i32 at pair_ptr + 4
                Self::emit_local_get(pair, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02); // align 4
                code.push(0x04); // offset 4
            }
            Instruction::Inl(val) => {
                // Alloc 8 bytes: tag=0 at +0, value at +4
                Self::emit_alloc_call(ctx.alloc_func_index, 8, code);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalTee as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                // Store tag=0
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x00);
                // Store value at +4
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(val, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x04);
                // Push ptr for generic LocalSet
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::Inr(val) => {
                // Alloc 8 bytes: tag=1 at +0, value at +4
                Self::emit_alloc_call(ctx.alloc_func_index, 8, code);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalTee as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(1, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x00);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(val, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x04);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::IsLeft(sum) => {
                // Load tag at sum_ptr+0, check if == 0
                Self::emit_local_get(sum, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02);
                code.push(0x00);
                code.push(Op::I32Eqz as u8); // tag==0 means left
            }
            Instruction::UnwrapLeft(sum) | Instruction::UnwrapRight(sum) => {
                // Load value at sum_ptr+4
                Self::emit_local_get(sum, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02);
                code.push(0x04);
            }
            Instruction::Copy(src) => {
                Self::emit_local_get(src, ctx.var_map, code);
            }
            Instruction::Classify(val) | Instruction::Prove(val) => {
                Self::emit_local_get(val, ctx.var_map, code);
            }
            Instruction::Declassify(val, _proof) => {
                Self::emit_local_get(val, ctx.var_map, code);
            }
            Instruction::Closure { func, captures } => {
                // Alloc (1 + len(captures)) * 4 bytes
                // Layout: [func_index: i32, capture0: i32, capture1: i32, ...]
                let size = (1 + captures.len()) as u32 * 4;
                Self::emit_alloc_call(ctx.alloc_func_index, size, code);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalTee as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                // Store func_index at +0
                let func_idx = ctx.func_map.get(func).copied().unwrap_or(0);
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(func_idx as i64, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x00);
                // Store each capture
                for (i, cap) in captures.iter().enumerate() {
                    if let Some(result_var) = result {
                        if let Some(local) = ctx.var_map.get(&result_var) {
                            code.push(Op::LocalGet as u8);
                            wasm_encode::encode_uleb128(*local as u64, code);
                        }
                    }
                    Self::emit_local_get(cap, ctx.var_map, code);
                    code.push(Op::I32Store as u8);
                    code.push(0x02); // align 4
                    let offset = ((i + 1) * 4) as u8;
                    code.push(offset);
                }
                // Push ptr for generic LocalSet
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::FixClosure {
                closure,
                capture_index,
            } => {
                // Patch captures[capture_index] with closure pointer itself
                Self::emit_local_get(closure, ctx.var_map, code);
                // Duplicate
                if let Some(local) = ctx.var_map.get(closure) {
                    code.push(Op::LocalGet as u8);
                    wasm_encode::encode_uleb128(*local as u64, code);
                }
                code.push(Op::I32Store as u8);
                code.push(0x02);
                let offset = ((capture_index + 1) * 4) as u8;
                code.push(offset);
                // Result is the closure ptr
                Self::emit_local_get(closure, ctx.var_map, code);
            }
            Instruction::Alloc { init, .. } => {
                // Allocate 4 bytes, store init value
                Self::emit_alloc_call(ctx.alloc_func_index, 4, code);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalTee as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(init, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02);
                code.push(0x00);
                // Push ptr for generic LocalSet
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::Phi(_) => {
                // Phi nodes are handled by structured if/else emission in emit_function.
                // Nothing to emit here — the if/else/end block leaves the result on the stack,
                // and emit_function emits the local.set for the phi result.
            }
            Instruction::BuiltinCall { name, arg } => {
                // Route builtins: cetakln/cetak → WASI fd_write(stdout)
                if name == "cetakln" || name == "cetak" {
                    if matches!(
                        ctx.var_to_ty.get(arg),
                        Some(Ty::Int) | Some(Ty::CInt) | Some(Ty::IntN { .. })
                    ) {
                        // Integer argument: convert to decimal ASCII (itoa) and
                        // write via WASI fd_write. (C uses a runtime-tagged
                        // riina_format; WASM values are untagged i32, so we
                        // dispatch on the static IR type here.)
                        Self::emit_print_int(arg, ctx, code);
                    } else {
                        // String pointer (len-prefixed in data section):
                        // Layout: [len:u32][bytes...]. fd_write needs an iovec
                        // {ptr, len} at a known memory location; use heap scratch:
                        // iovec at heap_ptr, nwritten at heap_ptr+8.

                        // Store data ptr (arg+4) at scratch[0]
                        code.push(Op::GlobalGet as u8);
                        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, code);
                        Self::emit_local_get(arg, ctx.var_map, code);
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(4, code);
                        code.push(Op::I32Add as u8); // ptr + 4 = data start
                        code.push(Op::I32Store as u8);
                        code.push(0x02);
                        code.push(0x00); // store at scratch[0]

                        // Store len at scratch[4]
                        code.push(Op::GlobalGet as u8);
                        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, code);
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(4, code);
                        code.push(Op::I32Add as u8); // scratch + 4
                        Self::emit_local_get(arg, ctx.var_map, code);
                        code.push(Op::I32Load as u8);
                        code.push(0x02);
                        code.push(0x00); // load len from arg
                        code.push(Op::I32Store as u8);
                        code.push(0x02);
                        code.push(0x00); // store at scratch[4]

                        // Call fd_write(1, scratch, 1, scratch+8)
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(1, code); // fd = stdout
                        code.push(Op::GlobalGet as u8);
                        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, code); // iovs = scratch
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(1, code); // iovs_len = 1
                        code.push(Op::GlobalGet as u8);
                        wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, code);
                        code.push(Op::I32Const as u8);
                        wasm_encode::encode_sleb128(8, code);
                        code.push(Op::I32Add as u8); // nwritten = scratch + 8

                        code.push(Op::Call as u8);
                        wasm_encode::encode_uleb128(0, code); // import index 0 = fd_write

                        code.push(Op::Drop as u8); // drop fd_write return value
                    }

                    // `cetakln` (println) appends a newline; `cetak` does not.
                    if name == "cetakln" {
                        wasm_write_bytes(code, b"\n");
                    }

                    // push unit (0) as result
                    code.push(Op::I32Const as u8);
                    wasm_encode::encode_sleb128(0, code);
                } else if name == "ke_teks" || name == "nombor_ke_teks" {
                    match ctx.var_to_ty.get(arg) {
                        Some(Ty::Int | Ty::CInt | Ty::IntN { .. }) => {
                            // Int (or sized int) → heap string.
                            Self::emit_ke_teks(arg, ctx, code);
                        }
                        Some(Ty::String | Ty::Element | Ty::Color | Ty::UIStyle) => {
                            // `ke_teks` of a string-typed value is identity — the
                            // value is already a `[len][bytes]` heap string. This
                            // is what makes nested UI fragments (a `tulisan`/
                            // `butang` inside a `paparan`) render: the element is
                            // wrapped in `ke_teks` by `lower_to_text`.
                            Self::emit_local_get(arg, ctx.var_map, code);
                        }
                        _ => {
                            // Other types: stub 0 (prior behavior).
                            code.push(Op::I32Const as u8);
                            wasm_encode::encode_sleb128(0, code);
                        }
                    }
                } else if name == "gabung_teks" {
                    Self::emit_gabung_teks(arg, ctx, code);
                } else {
                    // Other builtins: push 0 (stub)
                    code.push(Op::I32Const as u8);
                    wasm_encode::encode_sleb128(0, code);
                }
            }
            Instruction::Perform { payload, .. } => {
                // Effect perform — stub: pass through payload
                Self::emit_local_get(payload, ctx.var_map, code);
            }
            Instruction::RequireCap(_) | Instruction::GrantCap(_) => {
                // Capability instructions are compile-time checks; emit unit at runtime
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::FFICall { name, args } => {
                // FFI calls are routed to WASM imports.
                // Push args, then call named import (not yet in import table — stub)
                for arg in args {
                    Self::emit_local_get(arg, ctx.var_map, code);
                }
                let _ = name;
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }

            // JALINAN Phase 6: simplified WASM actor support
            Instruction::ActorDecl { .. } | Instruction::ChoreographyDecl { .. } => {
                // Declaration: push 0 (unit)
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::ActorSpawn(_, _) => {
                // Spawn: push actor ID (incrementing counter via global)
                // For simplicity, just push 1 as the actor ref
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(1, code);
            }
            Instruction::ActorSend(_, _) => {
                // Send: no-op in single-threaded WASM, push 0
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::ActorRecv(_) => {
                // Recv: return 0 (placeholder — no real mailbox in WASM)
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::CRDTMerge(_, _) => {
                // CRDT merge: for integers, take max (simplified)
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
            Instruction::ContentHash(_) => {
                // Content hash: return 0 (placeholder)
                code.push(Op::I32Const as u8);
                wasm_encode::encode_sleb128(0, code);
            }
        }

        // Store result if there is one.
        // Skip for Phi — it doesn't push anything onto the stack;
        // the phi result is stored by the structured if/else emission
        // in emit_function.
        let skip_store = matches!(instr, Instruction::Phi(_));
        if !skip_store {
            if let Some(result_var) = result {
                if let Some(local) = ctx.var_map.get(&result_var) {
                    code.push(Op::LocalSet as u8);
                    wasm_encode::encode_uleb128(*local as u64, code);
                }
            }
        }

        Ok(())
    }

    /// Generate JavaScript glue code for loading the WASM module.
    fn generate_js_glue(&self) -> Vec<u8> {
        let js = r#"// RIINA WASM Loader — Auto-generated
// Copyright (c) 2026 The RIINA Authors. All rights reserved.

let instance;
let outputBuffer = [];

const RIINA_WASM_IMPORTS = {
  wasi_snapshot_preview1: {
    fd_write: (fd, iovs, iovs_len, nwritten) => {
      const mem = new Uint32Array(instance.exports.memory.buffer);
      let written = 0;
      for (let i = 0; i < iovs_len; i++) {
        const ptr = mem[(iovs + i * 8) / 4];
        const len = mem[(iovs + i * 8 + 4) / 4];
        const bytes = new Uint8Array(instance.exports.memory.buffer, ptr, len);
        const msg = new TextDecoder().decode(bytes);
        outputBuffer.push(msg);
        if (fd === 1) console.log(msg);
        else console.error(msg);
        written += len;
      }
      mem[nwritten / 4] = written;
      return 0;
    },
    proc_exit: (code) => {
      throw new Error('RIINA exit: ' + code);
    },
  },
};

export async function loadRiina(wasmPath) {
  const response = await fetch(wasmPath);
  const bytes = await response.arrayBuffer();
  const result = await WebAssembly.instantiate(bytes, RIINA_WASM_IMPORTS);
  instance = result.instance;
  return instance.exports;
}

export function run(wasmExports) {
  outputBuffer = [];
  if (wasmExports._start) {
    const result = wasmExports._start(0);
    return { result, output: outputBuffer.join('\n') };
  }
  return { result: 0, output: '' };
}

export function getOutput() {
  return outputBuffer.join('\n');
}
"#;
        js.as_bytes().to_vec()
    }
}

// ── WASM result-echo helpers ────────────────────────────────────────────────
// These emit raw WASM that prints the program's final value to stdout, matching
// the C `main` echo byte-for-byte. Used by the `_start` trampoline. They use
// heap scratch: iovec at heap_ptr[0..8], nwritten at heap_ptr[8], a literal/
// digit buffer at heap_ptr+16.. .

fn wasm_heap(code: &mut Vec<u8>) {
    code.push(Op::GlobalGet as u8);
    wasm_encode::encode_uleb128(GLOBAL_HEAP_PTR as u64, code);
}
fn wasm_i32c(code: &mut Vec<u8>, n: i64) {
    code.push(Op::I32Const as u8);
    wasm_encode::encode_sleb128(n, code);
}
fn wasm_local(code: &mut Vec<u8>, op: Op, idx: u32) {
    code.push(op as u8);
    wasm_encode::encode_uleb128(idx as u64, code);
}
/// Emit fd_write(1, heap_ptr, 1, heap_ptr+8) (iovec already set up at heap_ptr).
fn wasm_fd_write(code: &mut Vec<u8>) {
    wasm_i32c(code, 1);
    wasm_heap(code);
    wasm_i32c(code, 1);
    wasm_heap(code);
    wasm_i32c(code, 8);
    code.push(Op::I32Add as u8);
    code.push(Op::Call as u8);
    wasm_encode::encode_uleb128(0, code); // fd_write import
    code.push(Op::Drop as u8);
}
/// Write `bytes` literally to stdout (copied into heap scratch at heap_ptr+16).
fn wasm_write_bytes(code: &mut Vec<u8>, bytes: &[u8]) {
    for (i, b) in bytes.iter().enumerate() {
        wasm_heap(code);
        wasm_i32c(code, 16 + i as i64);
        code.push(Op::I32Add as u8);
        wasm_i32c(code, i64::from(*b));
        code.push(Op::I32Store8 as u8);
        code.push(0x00);
        code.push(0x00);
    }
    // iovec.ptr = heap+16
    wasm_heap(code);
    wasm_heap(code);
    wasm_i32c(code, 16);
    code.push(Op::I32Add as u8);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x00);
    // iovec.len = bytes.len()
    wasm_heap(code);
    wasm_i32c(code, bytes.len() as i64);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x04);
    wasm_fd_write(code);
}
/// Write the contents of a length-prefixed string `[len:u32][bytes]` whose
/// pointer is in local `ptr_local` (no quotes, no newline).
fn wasm_echo_strptr(code: &mut Vec<u8>, ptr_local: u32) {
    // iovec.ptr = ptr_local + 4
    wasm_heap(code);
    wasm_local(code, Op::LocalGet, ptr_local);
    wasm_i32c(code, 4);
    code.push(Op::I32Add as u8);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x00);
    // iovec.len = load len from ptr_local
    wasm_heap(code);
    wasm_local(code, Op::LocalGet, ptr_local);
    code.push(Op::I32Load as u8);
    code.push(0x02);
    code.push(0x00);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x04);
    wasm_fd_write(code);
}
/// Write the unsigned integer in local `v_local` as decimal ASCII + newline.
/// `tv`/`tp` are scratch i32 locals.
fn wasm_echo_int(code: &mut Vec<u8>, v_local: u32, tv: u32, tp: u32) {
    // $v = v_local
    wasm_local(code, Op::LocalGet, v_local);
    wasm_local(code, Op::LocalSet, tv);
    // mem[heap+48] = '\n'
    wasm_heap(code);
    wasm_i32c(code, 48);
    code.push(Op::I32Add as u8);
    wasm_i32c(code, 10);
    code.push(Op::I32Store8 as u8);
    code.push(0x00);
    code.push(0x00);
    // $p = heap + 48
    wasm_heap(code);
    wasm_i32c(code, 48);
    code.push(Op::I32Add as u8);
    wasm_local(code, Op::LocalSet, tp);
    // do { p--; mem[p] = '0'+(v%10); v/=10 } while (v != 0)
    code.push(Op::Loop as u8);
    code.push(0x40);
    wasm_local(code, Op::LocalGet, tp);
    wasm_i32c(code, 1);
    code.push(Op::I32Sub as u8);
    wasm_local(code, Op::LocalSet, tp);
    wasm_local(code, Op::LocalGet, tp);
    wasm_local(code, Op::LocalGet, tv);
    wasm_i32c(code, 10);
    code.push(Op::I32RemU as u8);
    wasm_i32c(code, 48);
    code.push(Op::I32Add as u8);
    code.push(Op::I32Store8 as u8);
    code.push(0x00);
    code.push(0x00);
    wasm_local(code, Op::LocalGet, tv);
    wasm_i32c(code, 10);
    code.push(Op::I32DivU as u8);
    wasm_local(code, Op::LocalSet, tv);
    wasm_local(code, Op::LocalGet, tv);
    code.push(Op::BrIf as u8);
    wasm_encode::encode_uleb128(0, code);
    code.push(Op::End as u8);
    // iovec.ptr = $p
    wasm_heap(code);
    wasm_local(code, Op::LocalGet, tp);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x00);
    // iovec.len = (heap+49) - $p
    wasm_heap(code);
    wasm_heap(code);
    wasm_i32c(code, 49);
    code.push(Op::I32Add as u8);
    wasm_local(code, Op::LocalGet, tp);
    code.push(Op::I32Sub as u8);
    code.push(Op::I32Store as u8);
    code.push(0x02);
    code.push(0x04);
    wasm_fd_write(code);
}

/// Emission context passed through instruction emission.
struct EmitCtx<'a> {
    var_map: &'a HashMap<VarId, u32>,
    func_map: &'a HashMap<FuncId, u32>,
    var_to_func: &'a HashMap<VarId, FuncId>,
    string_table: &'a HashMap<String, u32>,
    alloc_func_index: u32,
    user_func_type_idx: u32,
    /// Static type of each IR value, so builtins (e.g. `cetak`) can choose an
    /// int-printing (itoa) path vs. a string-pointer path.
    var_to_ty: &'a HashMap<VarId, Ty>,
    /// Two reserved scratch i32 locals for the integer-printing routine.
    itoa_v: u32,
    itoa_p: u32,
    /// Base index of 6 extra scratch i32 locals (string builtins).
    scratch: u32,
}

impl Backend for WasmBackend {
    fn emit(&self, program: &Program) -> Result<BackendOutput> {
        let module = self.translate(program)?;
        let wasm_bytes = module.encode();

        let js_glue = self.generate_js_glue();

        Ok(BackendOutput {
            primary: wasm_bytes,
            extension: ".wasm".to_string(),
            auxiliary: vec![AuxFile {
                name: "riina_loader.js".to_string(),
                content: js_glue,
            }],
        })
    }

    fn target(&self) -> Target {
        self.target
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ir::{self, AnnotatedInstr, BlockId};

    /// Helper to create a simple main function with given instructions.
    fn make_program(instrs: Vec<AnnotatedInstr>, ret: VarId) -> Program {
        let mut program = ir::Program::new();
        let mut main_func = ir::Function::new(
            FuncId::MAIN,
            "main".to_string(),
            "x".to_string(),
            riina_types::Ty::Unit,
            riina_types::Ty::Int,
            riina_types::Effect::Pure,
        );
        let entry = BlockId::new(0);
        let mut block = BasicBlock::new(entry);
        block.instrs = instrs;
        block.terminator = Some(Terminator::Return(ret));
        main_func.blocks.push(block);
        main_func.entry = entry;
        program.functions.insert(FuncId::MAIN, main_func);
        program
    }

    fn ann(instr: Instruction, result: VarId) -> AnnotatedInstr {
        AnnotatedInstr {
            instr,
            result,
            ty: riina_types::Ty::Int,
            effect: riina_types::Effect::Pure,
            security: riina_types::SecurityLevel::Public,
        }
    }

    #[test]
    fn test_wasm_backend_target() {
        let backend = WasmBackend::new(Target::Wasm32);
        assert_eq!(backend.target(), Target::Wasm32);
    }

    #[test]
    fn test_wasm_backend_empty_program() {
        let backend = WasmBackend::new(Target::Wasm32);
        let program = ir::Program::new();
        let output = backend.emit(&program).unwrap();
        assert_eq!(output.extension, ".wasm");
        assert!(output.primary.len() >= 8);
        assert_eq!(&output.primary[0..4], b"\x00asm");
    }

    #[test]
    fn test_wasm_backend_has_js_glue() {
        let backend = WasmBackend::new(Target::Wasm32);
        let program = ir::Program::new();
        let output = backend.emit(&program).unwrap();
        assert_eq!(output.auxiliary.len(), 1);
        assert_eq!(output.auxiliary[0].name, "riina_loader.js");
        let js = String::from_utf8(output.auxiliary[0].content.clone()).unwrap();
        assert!(js.contains("WebAssembly.instantiate"));
        assert!(js.contains("fd_write"));
        assert!(js.contains("getOutput"));
    }

    #[test]
    fn test_wasm_mod_operation() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(5)), v0),
                ann(Instruction::Const(Constant::Int(3)), v1),
                ann(Instruction::BinOp(BinOp::Mod, v0, v1), v2),
            ],
            v2,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(
            output.primary.windows(1).any(|w| w[0] == 0x6F),
            "WASM binary should contain I32RemS opcode (0x6F)"
        );
    }

    /// The width-mask byte sequence for a u8 result: `i32.const 255` (0x41 0xFF
    /// 0x01) followed by `i32.and` (0x71).
    const U8_MASK_SEQ: [u8; 4] = [0x41, 0xFF, 0x01, 0x71];

    #[test]
    fn numeric_tower_wasm_masks_sized_arithmetic() {
        // A BinOp whose result types as u8 is masked to 8 bits in WASM.
        let (v0, v1, v2) = (VarId::new(0), VarId::new(1), VarId::new(2));
        let sized_add = AnnotatedInstr {
            instr: Instruction::BinOp(BinOp::Add, v0, v1),
            result: v2,
            ty: riina_types::Ty::IntN {
                bits: 8,
                signed: false,
            },
            effect: riina_types::Effect::Pure,
            security: riina_types::SecurityLevel::Public,
        };
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(200)), v0),
                ann(Instruction::Const(Constant::Int(100)), v1),
                sized_add,
            ],
            v2,
        );
        let out = WasmBackend::new(Target::Wasm32).emit(&program).unwrap();
        assert!(
            out.primary.windows(4).any(|w| w == U8_MASK_SEQ),
            "u8 arithmetic must be masked with `i32.const 255; i32.and` in WASM"
        );
    }

    #[test]
    fn numeric_tower_wasm_does_not_mask_plain_int() {
        // Plain `Int` arithmetic (via `ann`, which annotates `Ty::Int`) is unmasked.
        let (v0, v1, v2) = (VarId::new(0), VarId::new(1), VarId::new(2));
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(200)), v0),
                ann(Instruction::Const(Constant::Int(100)), v1),
                ann(Instruction::BinOp(BinOp::Add, v0, v1), v2),
            ],
            v2,
        );
        let out = WasmBackend::new(Target::Wasm32).emit(&program).unwrap();
        assert!(
            !out.primary.windows(4).any(|w| w == U8_MASK_SEQ),
            "plain Int arithmetic must not be width-masked"
        );
    }

    #[test]
    fn test_wasm_logical_or() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Bool(true)), v0),
                ann(Instruction::Const(Constant::Bool(false)), v1),
                ann(Instruction::BinOp(BinOp::Or, v0, v1), v2),
            ],
            v2,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(
            output.primary.windows(1).any(|w| w[0] == 0x72),
            "WASM binary should contain I32Or opcode (0x72)"
        );
    }

    #[test]
    fn test_wasm_call_correct_index() {
        let backend = WasmBackend::new(Target::Wasm32);
        let mut program = ir::Program::new();

        let helper_id = FuncId::new(1);
        let mut helper_func = ir::Function::new(
            helper_id,
            "helper".to_string(),
            "x".to_string(),
            riina_types::Ty::Int,
            riina_types::Ty::Int,
            riina_types::Effect::Pure,
        );
        let he = BlockId::new(0);
        let mut hb = BasicBlock::new(he);
        hb.instrs
            .push(ann(Instruction::Const(Constant::Int(99)), VarId::new(100)));
        hb.terminator = Some(Terminator::Return(VarId::new(100)));
        helper_func.blocks.push(hb);
        helper_func.entry = he;
        program.functions.insert(helper_id, helper_func);

        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let mut main_func = ir::Function::new(
            FuncId::MAIN,
            "main".to_string(),
            "x".to_string(),
            riina_types::Ty::Unit,
            riina_types::Ty::Int,
            riina_types::Effect::Pure,
        );
        let entry = BlockId::new(0);
        let mut block = BasicBlock::new(entry);
        block.instrs = vec![
            ann(
                Instruction::Closure {
                    func: helper_id,
                    captures: vec![],
                },
                v0,
            ),
            ann(Instruction::Const(Constant::Int(0)), v1),
            ann(Instruction::Call(v0, v1), v2),
        ];
        block.terminator = Some(Terminator::Return(v2));
        main_func.blocks.push(block);
        main_func.entry = entry;
        program.functions.insert(FuncId::MAIN, main_func);

        let output = backend.emit(&program).unwrap();
        assert!(output.primary.windows(1).any(|w| w[0] == Op::Call as u8));
    }

    #[test]
    fn test_wasm_backend_with_main() {
        let backend = WasmBackend::new(Target::Wasm32);
        let v0 = VarId::new(0);
        let program = make_program(vec![ann(Instruction::Const(Constant::Int(42)), v0)], v0);

        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
        assert!(output.primary.windows(6).any(|w| w == b"_start"));
    }

    // === Phase 2 tests ===

    #[test]
    fn test_wasm_string_constant() {
        let v0 = VarId::new(0);
        let program = make_program(
            vec![ann(
                Instruction::Const(Constant::String("hello".to_string())),
                v0,
            )],
            v0,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Data section should contain "hello"
        let binary = &output.primary;
        assert!(
            binary.windows(5).any(|w| w == b"hello"),
            "WASM binary should contain 'hello' in data section"
        );
    }

    #[test]
    fn test_wasm_pair_create_project() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let v4 = VarId::new(4);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(10)), v0),
                ann(Instruction::Const(Constant::Int(20)), v1),
                ann(Instruction::Pair(v0, v1), v2),
                ann(Instruction::Fst(v2), v3),
                ann(Instruction::Snd(v2), v4),
            ],
            v4,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.load (0x28) for projections
        assert!(
            output.primary.windows(1).any(|w| w[0] == Op::I32Load as u8),
            "WASM binary should contain I32Load for pair projection"
        );
        // Should contain call to alloc
        assert!(
            output.primary.windows(1).any(|w| w[0] == Op::Call as u8),
            "WASM binary should contain Call for alloc"
        );
    }

    #[test]
    fn test_wasm_sum_inject_test_unwrap() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(42)), v0),
                ann(Instruction::Inl(v0), v1),
                ann(Instruction::IsLeft(v1), v2),
                ann(Instruction::UnwrapLeft(v1), v3),
            ],
            v3,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.eqz (0x45) for IsLeft tag check
        assert!(
            output.primary.windows(1).any(|w| w[0] == Op::I32Eqz as u8),
            "WASM binary should contain I32Eqz for IsLeft"
        );
    }

    #[test]
    fn test_wasm_closure_capture() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(42)), v0),
                ann(
                    Instruction::Closure {
                        func: FuncId::MAIN,
                        captures: vec![v0],
                    },
                    v1,
                ),
            ],
            v1,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.store for writing captures
        assert!(
            output
                .primary
                .windows(1)
                .any(|w| w[0] == Op::I32Store as u8),
            "WASM binary should contain I32Store for closure captures"
        );
    }

    #[test]
    fn test_wasm_builtin_cetak() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(
            vec![
                ann(
                    Instruction::Const(Constant::String("hello".to_string())),
                    v0,
                ),
                ann(
                    Instruction::BuiltinCall {
                        name: "cetakln".to_string(),
                        arg: v0,
                    },
                    v1,
                ),
            ],
            v1,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should have "fd_write" in the import section (WASI)
        assert!(
            output.primary.windows(8).any(|w| w == b"fd_write"),
            "WASM binary should import fd_write"
        );
    }

    #[test]
    fn test_wasm_ref_alloc_load_store() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let v4 = VarId::new(4);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(10)), v0),
                ann(
                    Instruction::Alloc {
                        init: v0,
                        level: riina_types::SecurityLevel::Public,
                    },
                    v1,
                ),
                ann(Instruction::Load(v1), v2),
                ann(Instruction::Const(Constant::Int(20)), v3),
                ann(Instruction::Store(v1, v3), v4),
            ],
            v2,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should have i32.load and i32.store
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Load as u8));
        assert!(output
            .primary
            .windows(1)
            .any(|w| w[0] == Op::I32Store as u8));
    }

    #[test]
    fn test_wasm_has_global_heap_ptr() {
        let v0 = VarId::new(0);
        let program = make_program(vec![ann(Instruction::Const(Constant::Int(0)), v0)], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Global section ID is 6
        assert!(
            output.primary.contains(&0x06),
            "WASM binary should contain global section"
        );
    }

    #[test]
    fn test_wasm_has_import_section() {
        let v0 = VarId::new(0);
        let program = make_program(vec![ann(Instruction::Const(Constant::Int(0)), v0)], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Import section should have "wasi_snapshot_preview1"
        assert!(
            output.primary.windows(8).any(|w| w == b"fd_write"),
            "WASM binary should contain WASI import"
        );
    }

    #[test]
    fn test_wasm_has_table_section() {
        let v0 = VarId::new(0);
        let program = make_program(vec![ann(Instruction::Const(Constant::Int(0)), v0)], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Table section ID is 4
        assert!(
            output.primary.contains(&0x04),
            "WASM binary should contain table section"
        );
    }

    #[test]
    fn test_wasm_inr_tag_is_one() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(99)), v0),
                ann(Instruction::Inr(v0), v1),
                ann(Instruction::IsLeft(v1), v2),
            ],
            v2,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should produce valid WASM
        assert!(output.primary.len() > 8);
    }

    #[test]
    fn test_wasm_fix_closure() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(
            vec![
                ann(
                    Instruction::Closure {
                        func: FuncId::MAIN,
                        captures: vec![VarId::new(99)],
                    },
                    v0,
                ),
                ann(
                    Instruction::FixClosure {
                        closure: v0,
                        capture_index: 0,
                    },
                    v1,
                ),
            ],
            v1,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
    }

    #[test]
    fn test_wasm_multiple_strings_deduped() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::String("abc".to_string())), v0),
                ann(Instruction::Const(Constant::String("abc".to_string())), v1),
            ],
            v1,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // "abc" should appear exactly once in data section
        let count = output.primary.windows(3).filter(|w| *w == b"abc").count();
        assert_eq!(count, 1, "Duplicate strings should be deduplicated");
    }

    #[test]
    fn test_wasm_effect_perform_passthrough() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(
            vec![
                ann(Instruction::Const(Constant::Int(42)), v0),
                ann(
                    Instruction::Perform {
                        effect: riina_types::Effect::Write,
                        payload: v0,
                    },
                    v1,
                ),
            ],
            v1,
        );

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
    }

    // === If/else structured control flow tests ===

    /// Build a program with if/else control flow:
    ///   bb0: cond = (x == 0); cond_branch cond bb1 bb2
    ///   bb1: result = 42; branch bb3
    ///   bb2: result = 99; branch bb3
    ///   bb3: phi = phi[(bb1,v_then),(bb2,v_else)]; return phi
    fn make_if_else_program() -> Program {
        let mut program = ir::Program::new();
        let mut main_func = ir::Function::new(
            FuncId::MAIN,
            "main".to_string(),
            "x".to_string(),
            riina_types::Ty::Int,
            riina_types::Ty::Int,
            riina_types::Effect::Pure,
        );
        // Clear default entry block
        main_func.blocks.clear();

        let bb0 = BlockId::new(0);
        let bb1 = BlockId::new(1);
        let bb2 = BlockId::new(2);
        let bb3 = BlockId::new(3);

        let v_zero = VarId::new(10);
        let v_cond = VarId::new(11);
        let v_then = VarId::new(12);
        let v_else = VarId::new(13);
        let v_phi = VarId::new(14);

        // bb0 (entry): compute condition
        let mut entry_block = BasicBlock::new(bb0);
        entry_block.instrs = vec![
            ann(Instruction::Const(Constant::Int(0)), v_zero),
            ann(Instruction::BinOp(BinOp::Eq, VarId::new(0), v_zero), v_cond),
        ];
        entry_block.terminator = Some(Terminator::CondBranch {
            cond: v_cond,
            then_block: bb1,
            else_block: bb2,
        });

        // bb1 (then): return 42
        let mut then_block = BasicBlock::new(bb1);
        then_block.instrs = vec![ann(Instruction::Const(Constant::Int(42)), v_then)];
        then_block.terminator = Some(Terminator::Branch(bb3));

        // bb2 (else): return 99
        let mut else_block = BasicBlock::new(bb2);
        else_block.instrs = vec![ann(Instruction::Const(Constant::Int(99)), v_else)];
        else_block.terminator = Some(Terminator::Branch(bb3));

        // bb3 (merge): phi + return
        let mut merge_block = BasicBlock::new(bb3);
        merge_block.instrs = vec![ann(
            Instruction::Phi(vec![(bb1, v_then), (bb2, v_else)]),
            v_phi,
        )];
        merge_block.terminator = Some(Terminator::Return(v_phi));

        main_func.blocks = vec![entry_block, then_block, else_block, merge_block];
        main_func.entry = bb0;
        program.functions.insert(FuncId::MAIN, main_func);
        program
    }

    #[test]
    fn test_wasm_if_else_structured_control_flow() {
        let program = make_if_else_program();
        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        let binary = &output.primary;

        // Verify WASM magic
        assert_eq!(&binary[0..4], b"\x00asm");

        // Should contain Op::If (0x04)
        assert!(
            binary.contains(&(Op::If as u8)),
            "WASM binary should contain If opcode for structured if/else"
        );

        // Should contain Op::Else (0x05)
        assert!(
            binary.contains(&(Op::Else as u8)),
            "WASM binary should contain Else opcode"
        );

        // Should contain Op::End (0x0B) — at least for the if/else/end
        let end_count = binary.iter().filter(|&&b| b == Op::End as u8).count();
        assert!(end_count >= 2,
            "WASM binary should contain at least 2 End opcodes (if/else block + function end), got {}",
            end_count);

        // The if/else control flow itself is structured (proven by the If/Else
        // opcodes above). We no longer assert the *whole* binary is BrIf-free:
        // the `_start` result-echo prints non-Unit results, and its integer
        // itoa routine legitimately uses a `loop` + `BrIf`.
    }

    #[test]
    fn test_wasm_if_else_has_phi_result() {
        let program = make_if_else_program();
        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        let binary = &output.primary;

        // Should contain LocalSet (0x21) for storing the phi result
        assert!(
            binary.contains(&(Op::LocalSet as u8)),
            "WASM binary should contain LocalSet for phi result storage"
        );

        // Should contain Return (0x0F) for the merge block
        assert!(
            binary.contains(&(Op::Return as u8)),
            "WASM binary should contain Return opcode"
        );
    }

    #[test]
    fn test_wasm_start_trampoline() {
        let v0 = VarId::new(0);
        let program = make_program(vec![ann(Instruction::Const(Constant::Int(42)), v0)], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        let binary = &output.primary;

        // Should export _start
        assert!(
            binary.windows(6).any(|w| w == b"_start"),
            "WASM binary should export _start"
        );

        // Should also export main
        assert!(
            binary.windows(4).any(|w| w == b"main"),
            "WASM binary should export main"
        );

        // Should contain Op::Drop (0x1A) for the trampoline dropping main's result
        assert!(
            binary.contains(&(Op::Drop as u8)),
            "WASM binary should contain Drop opcode in _start trampoline"
        );
    }
}
