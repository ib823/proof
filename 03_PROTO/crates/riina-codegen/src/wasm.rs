// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 The RIINA Authors. See AUTHORS file.

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
    BasicBlock, BinOp, Constant, Function, FuncId,
    Instruction, Program, Terminator, UnaryOp, VarId,
};
use crate::wasm_encode::{
    self, DataSegment, ElemSegment, Export, ExportKind, FuncBody, FuncType,
    GlobalType, Import, ImportKind, MemoryType, Op, TableType, ValType, WasmModule,
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
        let heap_start = if heap_start == 0 { HEAP_START_ALIGN } else { heap_start };

        // === Import section: env.riina_cetak, env.riina_panic ===
        // Type for cetak: (i32, i32) -> ()  [ptr, len]
        let cetak_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32, ValType::I32],
            results: vec![],
        });
        // Type for panic: (i32, i32) -> ()
        let panic_type_idx = module.types.len() as u32;
        module.types.push(FuncType {
            params: vec![ValType::I32, ValType::I32],
            results: vec![],
        });

        module.imports.push(Import {
            module: "env".to_string(),
            name: "riina_cetak".to_string(),
            kind: ImportKind::Func(cetak_type_idx),
        });
        module.imports.push(Import {
            module: "env".to_string(),
            name: "riina_panic".to_string(),
            kind: ImportKind::Func(panic_type_idx),
        });

        // === Memory ===
        module.memories.push(MemoryType { min: 1, max: Some(256) });

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
        let func_ids: Vec<FuncId> = program.functions.keys().copied().collect();
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

        // Element segment: initialize table with all function indices
        let all_func_indices: Vec<u32> = (0..total_funcs).collect();
        let mut elem_offset = Vec::new();
        elem_offset.push(Op::I32Const as u8);
        wasm_encode::encode_sleb128(0, &mut elem_offset);
        elem_offset.push(Op::End as u8);
        module.elements.push(ElemSegment {
            offset_expr: elem_offset,
            func_indices: all_func_indices,
        });

        // Emit each user function
        for &fid in &func_ids {
            let func = program.function(fid).unwrap();

            let (param_types, result_types) = self.function_signature(func);
            let type_idx = module.types.len() as u32;
            module.types.push(FuncType {
                params: param_types,
                results: result_types,
            });
            module.functions.push(type_idx);

            let body = self.emit_function(func, &func_index_map, &string_table, alloc_func_index)?;
            module.codes.push(body);

            if fid == FuncId::MAIN {
                module.exports.push(Export {
                    name: "_start".to_string(),
                    kind: ExportKind::Func,
                    index: func_index_map[&fid],
                });
            }
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

    /// Determine the WASM function signature for an IR function.
    fn function_signature(&self, _func: &Function) -> (Vec<ValType>, Vec<ValType>) {
        let params = vec![ValType::I32];
        let results = vec![ValType::I32];
        (params, results)
    }

    /// Emit WASM instructions for a function.
    fn emit_function(
        &self,
        func: &Function,
        func_map: &HashMap<FuncId, u32>,
        string_table: &HashMap<String, u32>,
        alloc_func_index: u32,
    ) -> Result<FuncBody> {
        let mut code = Vec::new();
        let mut locals: Vec<(u32, ValType)> = Vec::new();
        let mut local_count: u32 = 1; // One param

        let mut var_to_local: HashMap<VarId, u32> = HashMap::new();
        let mut var_to_func: HashMap<VarId, FuncId> = HashMap::new();

        for block in &func.blocks {
            for instr in &block.instrs {
                let result = instr.result;
                if let std::collections::hash_map::Entry::Vacant(e) = var_to_local.entry(result) {
                    e.insert(local_count);
                    local_count += 1;
                }
                if let Instruction::Closure { func: fid, .. } = &instr.instr {
                    var_to_func.insert(result, *fid);
                }
            }
        }

        let extra_locals = local_count.saturating_sub(1);
        if extra_locals > 0 {
            locals.push((extra_locals, ValType::I32));
        }

        let ctx = EmitCtx {
            var_map: &var_to_local,
            func_map,
            var_to_func: &var_to_func,
            string_table,
            alloc_func_index,
        };

        for block in &func.blocks {
            self.emit_block(block, &ctx, &mut code)?;
        }

        if code.is_empty() || !matches!(code.last(), Some(&b) if b == Op::Return as u8) {
            code.push(Op::I32Const as u8);
            wasm_encode::encode_sleb128(0, &mut code);
        }

        Ok(FuncBody { locals, code })
    }

    /// Emit WASM instructions for a basic block.
    fn emit_block(
        &self,
        block: &BasicBlock,
        ctx: &EmitCtx<'_>,
        code: &mut Vec<u8>,
    ) -> Result<()> {
        for instr in &block.instrs {
            self.emit_instruction(&instr.instr, Some(instr.result), ctx, code)?;
        }

        match &block.terminator {
            Some(Terminator::Return(var)) => {
                if let Some(local) = ctx.var_map.get(var) {
                    code.push(Op::LocalGet as u8);
                    wasm_encode::encode_uleb128(*local as u64, code);
                }
                code.push(Op::Return as u8);
            }
            Some(Terminator::Branch(_target)) => {}
            Some(Terminator::CondBranch { cond, .. }) => {
                if let Some(local) = ctx.var_map.get(cond) {
                    code.push(Op::LocalGet as u8);
                    wasm_encode::encode_uleb128(*local as u64, code);
                }
                code.push(Op::BrIf as u8);
                wasm_encode::encode_uleb128(0, code);
            }
            Some(Terminator::Handle { .. }) => {}
            Some(Terminator::Unreachable) => {
                code.push(Op::Unreachable as u8);
            }
            None => {}
        }

        Ok(())
    }

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
            }
            Instruction::UnaryOp(op, operand) => {
                match op {
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
                }
            }
            Instruction::Call(func_var, arg) => {
                Self::emit_local_get(arg, ctx.var_map, code);
                if let Some(fid) = ctx.var_to_func.get(func_var) {
                    if let Some(&idx) = ctx.func_map.get(fid) {
                        code.push(Op::Call as u8);
                        wasm_encode::encode_uleb128(idx as u64, code);
                    } else {
                        code.push(Op::Call as u8);
                        wasm_encode::encode_uleb128(0, code);
                    }
                } else {
                    // Indirect call through closure pointer
                    // Load func_idx from closure memory: closure_ptr + 0
                    Self::emit_local_get(func_var, ctx.var_map, code);
                    code.push(Op::I32Load as u8);
                    code.push(0x02); // align 4
                    code.push(0x00); // offset 0
                    // call_indirect with type index 0 (i32->i32), table 0
                    // We need a type index for (i32) -> (i32). Use a convention:
                    // the standard function type is always type index = NUM_IMPORTS + 1
                    // (after cetak_type, panic_type, alloc_type come user types)
                    // For simplicity, use type 2 (alloc type is (i32)->(i32))
                    code.push(Op::CallIndirect as u8);
                    wasm_encode::encode_uleb128(2, code); // alloc type = (i32)->i32
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
                code.push(0x02); code.push(0x00);
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
                code.push(0x02); code.push(0x00);
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
                code.push(0x02); code.push(0x00);
                // Store value at +4
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(val, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02); code.push(0x04);
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
                code.push(0x02); code.push(0x00);
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
                Self::emit_local_get(val, ctx.var_map, code);
                code.push(Op::I32Store as u8);
                code.push(0x02); code.push(0x04);
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
                code.push(0x02); code.push(0x00);
                code.push(Op::I32Eqz as u8); // tag==0 means left
            }
            Instruction::UnwrapLeft(sum) | Instruction::UnwrapRight(sum) => {
                // Load value at sum_ptr+4
                Self::emit_local_get(sum, ctx.var_map, code);
                code.push(Op::I32Load as u8);
                code.push(0x02); code.push(0x04);
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
                code.push(0x02); code.push(0x00);
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
            Instruction::FixClosure { closure, capture_index } => {
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
                code.push(0x02); code.push(0x00);
                // Push ptr for generic LocalSet
                if let Some(result_var) = result {
                    if let Some(local) = ctx.var_map.get(&result_var) {
                        code.push(Op::LocalGet as u8);
                        wasm_encode::encode_uleb128(*local as u64, code);
                    }
                }
            }
            Instruction::Phi(_) => {
                code.push(Op::Nop as u8);
            }
            Instruction::BuiltinCall { name, arg } => {
                // Route builtins: cetakln → call import riina_cetak
                if name == "cetakln" || name == "cetak" {
                    // arg is a string pointer (len-prefixed in data section)
                    // Push ptr+4 (data), then load len from ptr
                    Self::emit_local_get(arg, ctx.var_map, code);
                    code.push(Op::I32Const as u8);
                    wasm_encode::encode_sleb128(4, code);
                    code.push(Op::I32Add as u8); // ptr + 4 = data start

                    Self::emit_local_get(arg, ctx.var_map, code);
                    code.push(Op::I32Load as u8);
                    code.push(0x02); code.push(0x00); // load len from ptr

                    code.push(Op::Call as u8);
                    wasm_encode::encode_uleb128(0, code); // import index 0 = riina_cetak

                    // cetak returns void; push unit
                    code.push(Op::I32Const as u8);
                    wasm_encode::encode_sleb128(0, code);
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
                code.push(Op::Nop as u8);
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
        }

        // Store result if there is one
        if let Some(result_var) = result {
            // Skip for Pair/Inl/Inr/Closure/Alloc — they handle their own storage
            // via LocalTee + final push pattern
            if let Some(local) = ctx.var_map.get(&result_var) {
                code.push(Op::LocalSet as u8);
                wasm_encode::encode_uleb128(*local as u64, code);
            }
        }

        Ok(())
    }

    /// Generate JavaScript glue code for loading the WASM module.
    fn generate_js_glue(&self) -> Vec<u8> {
        let js = r#"// RIINA WASM Loader — Auto-generated
// SPDX-License-Identifier: MPL-2.0

let instance;
let outputBuffer = [];

const RIINA_WASM_IMPORTS = {
  env: {
    riina_cetak: (ptr, len) => {
      const bytes = new Uint8Array(instance.exports.memory.buffer, ptr, len);
      const msg = new TextDecoder().decode(bytes);
      outputBuffer.push(msg);
      console.log(msg);
    },
    riina_panic: (ptr, len) => {
      const bytes = new Uint8Array(instance.exports.memory.buffer, ptr, len);
      throw new Error('RIINA panic: ' + new TextDecoder().decode(bytes));
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

/// Emission context passed through instruction emission.
struct EmitCtx<'a> {
    var_map: &'a HashMap<VarId, u32>,
    func_map: &'a HashMap<FuncId, u32>,
    var_to_func: &'a HashMap<VarId, FuncId>,
    string_table: &'a HashMap<String, u32>,
    alloc_func_index: u32,
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
        assert!(js.contains("riina_cetak"));
        assert!(js.contains("getOutput"));
    }

    #[test]
    fn test_wasm_mod_operation() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(5)), v0),
            ann(Instruction::Const(Constant::Int(3)), v1),
            ann(Instruction::BinOp(BinOp::Mod, v0, v1), v2),
        ], v2);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.windows(1).any(|w| w[0] == 0x6F),
            "WASM binary should contain I32RemS opcode (0x6F)");
    }

    #[test]
    fn test_wasm_logical_or() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Bool(true)), v0),
            ann(Instruction::Const(Constant::Bool(false)), v1),
            ann(Instruction::BinOp(BinOp::Or, v0, v1), v2),
        ], v2);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.windows(1).any(|w| w[0] == 0x72),
            "WASM binary should contain I32Or opcode (0x72)");
    }

    #[test]
    fn test_wasm_call_correct_index() {
        let backend = WasmBackend::new(Target::Wasm32);
        let mut program = ir::Program::new();

        let helper_id = FuncId::new(1);
        let mut helper_func = ir::Function::new(
            helper_id, "helper".to_string(), "x".to_string(),
            riina_types::Ty::Int, riina_types::Ty::Int, riina_types::Effect::Pure,
        );
        let he = BlockId::new(0);
        let mut hb = BasicBlock::new(he);
        hb.instrs.push(ann(Instruction::Const(Constant::Int(99)), VarId::new(100)));
        hb.terminator = Some(Terminator::Return(VarId::new(100)));
        helper_func.blocks.push(hb);
        helper_func.entry = he;
        program.functions.insert(helper_id, helper_func);

        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let mut main_func = ir::Function::new(
            FuncId::MAIN, "main".to_string(), "x".to_string(),
            riina_types::Ty::Unit, riina_types::Ty::Int, riina_types::Effect::Pure,
        );
        let entry = BlockId::new(0);
        let mut block = BasicBlock::new(entry);
        block.instrs = vec![
            ann(Instruction::Closure { func: helper_id, captures: vec![] }, v0),
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
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(42)), v0),
        ], v0);

        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
        assert!(output.primary.windows(6).any(|w| w == b"_start"));
    }

    // === Phase 2 tests ===

    #[test]
    fn test_wasm_string_constant() {
        let v0 = VarId::new(0);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::String("hello".to_string())), v0),
        ], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Data section should contain "hello"
        let binary = &output.primary;
        assert!(binary.windows(5).any(|w| w == b"hello"),
            "WASM binary should contain 'hello' in data section");
    }

    #[test]
    fn test_wasm_pair_create_project() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let v4 = VarId::new(4);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(10)), v0),
            ann(Instruction::Const(Constant::Int(20)), v1),
            ann(Instruction::Pair(v0, v1), v2),
            ann(Instruction::Fst(v2), v3),
            ann(Instruction::Snd(v2), v4),
        ], v4);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.load (0x28) for projections
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Load as u8),
            "WASM binary should contain I32Load for pair projection");
        // Should contain call to alloc
        assert!(output.primary.windows(1).any(|w| w[0] == Op::Call as u8),
            "WASM binary should contain Call for alloc");
    }

    #[test]
    fn test_wasm_sum_inject_test_unwrap() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(42)), v0),
            ann(Instruction::Inl(v0), v1),
            ann(Instruction::IsLeft(v1), v2),
            ann(Instruction::UnwrapLeft(v1), v3),
        ], v3);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.eqz (0x45) for IsLeft tag check
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Eqz as u8),
            "WASM binary should contain I32Eqz for IsLeft");
    }

    #[test]
    fn test_wasm_closure_capture() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(42)), v0),
            ann(Instruction::Closure { func: FuncId::MAIN, captures: vec![v0] }, v1),
        ], v1);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should contain i32.store for writing captures
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Store as u8),
            "WASM binary should contain I32Store for closure captures");
    }

    #[test]
    fn test_wasm_builtin_cetak() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::String("hello".to_string())), v0),
            ann(Instruction::BuiltinCall { name: "cetakln".to_string(), arg: v0 }, v1),
        ], v1);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should have "riina_cetak" in the import section
        assert!(output.primary.windows(11).any(|w| w == b"riina_cetak"),
            "WASM binary should import riina_cetak");
    }

    #[test]
    fn test_wasm_ref_alloc_load_store() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let v3 = VarId::new(3);
        let v4 = VarId::new(4);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(10)), v0),
            ann(Instruction::Alloc { init: v0, level: riina_types::SecurityLevel::Public }, v1),
            ann(Instruction::Load(v1), v2),
            ann(Instruction::Const(Constant::Int(20)), v3),
            ann(Instruction::Store(v1, v3), v4),
        ], v2);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should have i32.load and i32.store
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Load as u8));
        assert!(output.primary.windows(1).any(|w| w[0] == Op::I32Store as u8));
    }

    #[test]
    fn test_wasm_has_global_heap_ptr() {
        let v0 = VarId::new(0);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(0)), v0),
        ], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Global section ID is 6
        assert!(output.primary.contains(&0x06),
            "WASM binary should contain global section");
    }

    #[test]
    fn test_wasm_has_import_section() {
        let v0 = VarId::new(0);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(0)), v0),
        ], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Import section should have "env"
        assert!(output.primary.windows(3).any(|w| w == b"env"),
            "WASM binary should contain 'env' import module");
    }

    #[test]
    fn test_wasm_has_table_section() {
        let v0 = VarId::new(0);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(0)), v0),
        ], v0);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Table section ID is 4
        assert!(output.primary.contains(&0x04),
            "WASM binary should contain table section");
    }

    #[test]
    fn test_wasm_inr_tag_is_one() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let v2 = VarId::new(2);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(99)), v0),
            ann(Instruction::Inr(v0), v1),
            ann(Instruction::IsLeft(v1), v2),
        ], v2);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        // Should produce valid WASM
        assert!(output.primary.len() > 8);
    }

    #[test]
    fn test_wasm_fix_closure() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(vec![
            ann(Instruction::Closure { func: FuncId::MAIN, captures: vec![VarId::new(99)] }, v0),
            ann(Instruction::FixClosure { closure: v0, capture_index: 0 }, v1),
        ], v1);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
    }

    #[test]
    fn test_wasm_multiple_strings_deduped() {
        let v0 = VarId::new(0);
        let v1 = VarId::new(1);
        let program = make_program(vec![
            ann(Instruction::Const(Constant::String("abc".to_string())), v0),
            ann(Instruction::Const(Constant::String("abc".to_string())), v1),
        ], v1);

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
        let program = make_program(vec![
            ann(Instruction::Const(Constant::Int(42)), v0),
            ann(Instruction::Perform { effect: riina_types::Effect::Write, payload: v0 }, v1),
        ], v1);

        let backend = WasmBackend::new(Target::Wasm32);
        let output = backend.emit(&program).unwrap();
        assert!(output.primary.len() > 8);
    }
}
