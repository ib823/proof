// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! WASM Binary Encoder
//!
//! Hand-written WebAssembly binary format encoder. Emits valid .wasm binaries
//! per the WebAssembly specification (MVP + memory64 for wasm64).
//!
//! No external dependencies — all encoding is done manually for maximum
//! auditability and zero supply-chain risk.
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST

/// WASM magic number: `\0asm`
const WASM_MAGIC: [u8; 4] = [0x00, 0x61, 0x73, 0x6D];

/// WASM version 1
const WASM_VERSION: [u8; 4] = [0x01, 0x00, 0x00, 0x00];

/// WASM section IDs
#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum SectionId {
    Type = 1,
    Import = 2,
    Function = 3,
    Table = 4,
    Memory = 5,
    Global = 6,
    Export = 7,
    Element = 9,
    Code = 10,
    Data = 11,
}

/// WASM value types
#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum ValType {
    I32 = 0x7F,
    I64 = 0x7E,
    F64 = 0x7C,
}

/// WASM opcodes
#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum Op {
    Unreachable = 0x00,
    Nop = 0x01,
    Block = 0x02,
    Loop = 0x03,
    If = 0x04,
    Else = 0x05,
    End = 0x0B,
    Br = 0x0C,
    BrIf = 0x0D,
    Return = 0x0F,
    Call = 0x10,
    Drop = 0x1A,
    LocalGet = 0x20,
    LocalSet = 0x21,
    LocalTee = 0x22,
    I32Load = 0x28,
    I64Load = 0x29,
    I32Store = 0x36,
    I32Store8 = 0x3A,
    I64Store = 0x37,
    I32Const = 0x41,
    I64Const = 0x42,
    F64Const = 0x44,
    I32Eqz = 0x45,
    I32Eq = 0x46,
    I32Ne = 0x47,
    I32LtS = 0x48,
    I32GtS = 0x4A,
    I32LeS = 0x4C,
    I32GeS = 0x4E,
    I32Add = 0x6A,
    I32Sub = 0x6B,
    I32Mul = 0x6C,
    I32DivS = 0x6D,
    I32DivU = 0x6E,
    I32RemS = 0x6F,
    I32RemU = 0x70,
    I32And = 0x71,
    I32Or = 0x72,
    I64Add = 0x7C,
    I64Sub = 0x7D,
    I64Mul = 0x7E,
    I64DivS = 0x7F,
    GlobalGet = 0x23,
    GlobalSet = 0x24,
    CallIndirect = 0x11,
}

/// Encode an unsigned LEB128 integer.
pub fn encode_uleb128(mut value: u64, out: &mut Vec<u8>) {
    loop {
        let mut byte = (value & 0x7F) as u8;
        value >>= 7;
        if value != 0 {
            byte |= 0x80;
        }
        out.push(byte);
        if value == 0 {
            break;
        }
    }
}

/// Encode a signed LEB128 integer.
pub fn encode_sleb128(mut value: i64, out: &mut Vec<u8>) {
    let mut more = true;
    while more {
        let mut byte = (value & 0x7F) as u8;
        value >>= 7;
        if (value == 0 && byte & 0x40 == 0) || (value == -1 && byte & 0x40 != 0) {
            more = false;
        } else {
            byte |= 0x80;
        }
        out.push(byte);
    }
}

/// Encode a byte vector with its length prefix (LEB128).
pub fn encode_vec(data: &[u8], out: &mut Vec<u8>) {
    encode_uleb128(data.len() as u64, out);
    out.extend_from_slice(data);
}

/// WASM module builder.
///
/// Constructs a valid .wasm binary by accumulating sections.
/// Import entry.
#[derive(Debug, Clone)]
pub struct Import {
    pub module: String,
    pub name: String,
    pub kind: ImportKind,
}

/// Import kind.
#[derive(Debug, Clone)]
pub enum ImportKind {
    Func(u32), // type index
}

/// Global type.
#[derive(Debug, Clone)]
pub struct GlobalType {
    pub val_type: ValType,
    pub mutable: bool,
    /// Init expression bytes (e.g., i32.const 0, end)
    pub init: Vec<u8>,
}

/// Table type.
#[derive(Debug, Clone)]
pub struct TableType {
    pub min: u32,
    pub max: Option<u32>,
}

/// Element segment (active, table 0, offset expr).
#[derive(Debug, Clone)]
pub struct ElemSegment {
    pub offset_expr: Vec<u8>,
    pub func_indices: Vec<u32>,
}

/// Data segment (active, memory 0, offset expr).
#[derive(Debug, Clone)]
pub struct DataSegment {
    pub offset: u32,
    pub data: Vec<u8>,
}

pub struct WasmModule {
    /// Type section entries (function signatures)
    pub types: Vec<FuncType>,
    /// Import section
    pub imports: Vec<Import>,
    /// Function section (type indices)
    pub functions: Vec<u32>,
    /// Table section
    pub tables: Vec<TableType>,
    /// Memory section
    pub memories: Vec<MemoryType>,
    /// Global section
    pub globals: Vec<GlobalType>,
    /// Export section
    pub exports: Vec<Export>,
    /// Element section
    pub elements: Vec<ElemSegment>,
    /// Code section (function bodies)
    pub codes: Vec<FuncBody>,
    /// Data section
    pub data: Vec<DataSegment>,
}

/// Function type (signature).
#[derive(Debug, Clone)]
pub struct FuncType {
    pub params: Vec<ValType>,
    pub results: Vec<ValType>,
}

/// Memory type (limits).
#[derive(Debug, Clone)]
pub struct MemoryType {
    pub min: u32,
    pub max: Option<u32>,
}

/// Export entry.
#[derive(Debug, Clone)]
pub struct Export {
    pub name: String,
    pub kind: ExportKind,
    pub index: u32,
}

#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum ExportKind {
    Func = 0x00,
    Memory = 0x02,
}

/// Function body.
#[derive(Debug, Clone)]
pub struct FuncBody {
    pub locals: Vec<(u32, ValType)>,
    pub code: Vec<u8>,
}

impl Default for WasmModule {
    fn default() -> Self {
        Self::new()
    }
}

impl WasmModule {
    pub fn new() -> Self {
        Self {
            types: Vec::new(),
            imports: Vec::new(),
            functions: Vec::new(),
            tables: Vec::new(),
            memories: Vec::new(),
            globals: Vec::new(),
            exports: Vec::new(),
            elements: Vec::new(),
            codes: Vec::new(),
            data: Vec::new(),
        }
    }

    /// Encode the entire module to a .wasm binary.
    pub fn encode(&self) -> Vec<u8> {
        let mut out = Vec::with_capacity(4096);

        // Header
        out.extend_from_slice(&WASM_MAGIC);
        out.extend_from_slice(&WASM_VERSION);

        // Sections MUST be emitted in order of SectionId

        // 1. Type section
        if !self.types.is_empty() {
            let section = self.encode_type_section();
            self.write_section(SectionId::Type, &section, &mut out);
        }

        // 2. Import section
        if !self.imports.is_empty() {
            let section = self.encode_import_section();
            self.write_section(SectionId::Import, &section, &mut out);
        }

        // 3. Function section
        if !self.functions.is_empty() {
            let section = self.encode_function_section();
            self.write_section(SectionId::Function, &section, &mut out);
        }

        // 4. Table section
        if !self.tables.is_empty() {
            let section = self.encode_table_section();
            self.write_section(SectionId::Table, &section, &mut out);
        }

        // 5. Memory section
        if !self.memories.is_empty() {
            let section = self.encode_memory_section();
            self.write_section(SectionId::Memory, &section, &mut out);
        }

        // 6. Global section
        if !self.globals.is_empty() {
            let section = self.encode_global_section();
            self.write_section(SectionId::Global, &section, &mut out);
        }

        // 7. Export section
        if !self.exports.is_empty() {
            let section = self.encode_export_section();
            self.write_section(SectionId::Export, &section, &mut out);
        }

        // 9. Element section
        if !self.elements.is_empty() {
            let section = self.encode_element_section();
            self.write_section(SectionId::Element, &section, &mut out);
        }

        // 10. Code section
        if !self.codes.is_empty() {
            let section = self.encode_code_section();
            self.write_section(SectionId::Code, &section, &mut out);
        }

        // 11. Data section
        if !self.data.is_empty() {
            let section = self.encode_data_section();
            self.write_section(SectionId::Data, &section, &mut out);
        }

        out
    }

    fn write_section(&self, id: SectionId, content: &[u8], out: &mut Vec<u8>) {
        out.push(id as u8);
        encode_uleb128(content.len() as u64, out);
        out.extend_from_slice(content);
    }

    fn encode_type_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.types.len() as u64, &mut buf);
        for ty in &self.types {
            buf.push(0x60); // func type marker
            encode_uleb128(ty.params.len() as u64, &mut buf);
            for p in &ty.params {
                buf.push(*p as u8);
            }
            encode_uleb128(ty.results.len() as u64, &mut buf);
            for r in &ty.results {
                buf.push(*r as u8);
            }
        }
        buf
    }

    fn encode_function_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.functions.len() as u64, &mut buf);
        for &idx in &self.functions {
            encode_uleb128(idx as u64, &mut buf);
        }
        buf
    }

    fn encode_memory_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.memories.len() as u64, &mut buf);
        for mem in &self.memories {
            if let Some(max) = mem.max {
                buf.push(0x01); // has max
                encode_uleb128(mem.min as u64, &mut buf);
                encode_uleb128(max as u64, &mut buf);
            } else {
                buf.push(0x00); // no max
                encode_uleb128(mem.min as u64, &mut buf);
            }
        }
        buf
    }

    fn encode_export_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.exports.len() as u64, &mut buf);
        for export in &self.exports {
            encode_vec(export.name.as_bytes(), &mut buf);
            buf.push(export.kind as u8);
            encode_uleb128(export.index as u64, &mut buf);
        }
        buf
    }

    fn encode_code_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.codes.len() as u64, &mut buf);
        for body in &self.codes {
            let func_body = self.encode_func_body(body);
            encode_uleb128(func_body.len() as u64, &mut buf);
            buf.extend_from_slice(&func_body);
        }
        buf
    }

    fn encode_import_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.imports.len() as u64, &mut buf);
        for import in &self.imports {
            encode_vec(import.module.as_bytes(), &mut buf);
            encode_vec(import.name.as_bytes(), &mut buf);
            match &import.kind {
                ImportKind::Func(type_idx) => {
                    buf.push(0x00); // func
                    encode_uleb128(*type_idx as u64, &mut buf);
                }
            }
        }
        buf
    }

    fn encode_table_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.tables.len() as u64, &mut buf);
        for table in &self.tables {
            buf.push(0x70); // funcref
            if let Some(max) = table.max {
                buf.push(0x01);
                encode_uleb128(table.min as u64, &mut buf);
                encode_uleb128(max as u64, &mut buf);
            } else {
                buf.push(0x00);
                encode_uleb128(table.min as u64, &mut buf);
            }
        }
        buf
    }

    fn encode_global_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.globals.len() as u64, &mut buf);
        for global in &self.globals {
            buf.push(global.val_type as u8);
            buf.push(if global.mutable { 0x01 } else { 0x00 });
            buf.extend_from_slice(&global.init);
        }
        buf
    }

    fn encode_element_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.elements.len() as u64, &mut buf);
        for elem in &self.elements {
            buf.push(0x00); // active, table 0
            buf.extend_from_slice(&elem.offset_expr);
            encode_uleb128(elem.func_indices.len() as u64, &mut buf);
            for &idx in &elem.func_indices {
                encode_uleb128(idx as u64, &mut buf);
            }
        }
        buf
    }

    fn encode_data_section(&self) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(self.data.len() as u64, &mut buf);
        for seg in &self.data {
            buf.push(0x00); // active, memory 0
                            // offset expr: i32.const <offset>, end
            buf.push(Op::I32Const as u8);
            encode_sleb128(seg.offset as i64, &mut buf);
            buf.push(Op::End as u8);
            encode_vec(&seg.data, &mut buf);
        }
        buf
    }

    fn encode_func_body(&self, body: &FuncBody) -> Vec<u8> {
        let mut buf = Vec::new();
        encode_uleb128(body.locals.len() as u64, &mut buf);
        for &(count, ty) in &body.locals {
            encode_uleb128(count as u64, &mut buf);
            buf.push(ty as u8);
        }
        buf.extend_from_slice(&body.code);
        buf.push(Op::End as u8); // end of function
        buf
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_uleb128_zero() {
        let mut buf = Vec::new();
        encode_uleb128(0, &mut buf);
        assert_eq!(buf, vec![0x00]);
    }

    #[test]
    fn test_uleb128_small() {
        let mut buf = Vec::new();
        encode_uleb128(127, &mut buf);
        assert_eq!(buf, vec![0x7F]);
    }

    #[test]
    fn test_uleb128_multi_byte() {
        let mut buf = Vec::new();
        encode_uleb128(128, &mut buf);
        assert_eq!(buf, vec![0x80, 0x01]);
    }

    #[test]
    fn test_uleb128_large() {
        let mut buf = Vec::new();
        encode_uleb128(624485, &mut buf);
        assert_eq!(buf, vec![0xE5, 0x8E, 0x26]);
    }

    #[test]
    fn test_sleb128_positive() {
        let mut buf = Vec::new();
        encode_sleb128(42, &mut buf);
        assert_eq!(buf, vec![42]);
    }

    #[test]
    fn test_sleb128_negative() {
        let mut buf = Vec::new();
        encode_sleb128(-1, &mut buf);
        assert_eq!(buf, vec![0x7F]);
    }

    #[test]
    fn test_wasm_module_header() {
        let module = WasmModule::new();
        let bytes = module.encode();
        assert_eq!(&bytes[0..4], &WASM_MAGIC);
        assert_eq!(&bytes[4..8], &WASM_VERSION);
    }

    #[test]
    fn test_minimal_wasm_module() {
        let mut module = WasmModule::new();
        // Add a function type: () -> i32
        module.types.push(FuncType {
            params: vec![],
            results: vec![ValType::I32],
        });
        // Add function index pointing to type 0
        module.functions.push(0);
        // Add memory (1 page min)
        module.memories.push(MemoryType { min: 1, max: None });
        // Export function as "main"
        module.exports.push(Export {
            name: "main".to_string(),
            kind: ExportKind::Func,
            index: 0,
        });
        // Export memory
        module.exports.push(Export {
            name: "memory".to_string(),
            kind: ExportKind::Memory,
            index: 0,
        });
        // Function body: return 42
        let mut code = Vec::new();
        code.push(Op::I32Const as u8);
        encode_sleb128(42, &mut code);
        module.codes.push(FuncBody {
            locals: vec![],
            code,
        });

        let bytes = module.encode();
        // Should start with WASM magic
        assert_eq!(&bytes[0..4], &WASM_MAGIC);
        // Should be a valid binary (>8 bytes)
        assert!(bytes.len() > 8);
    }

    // ─── Structural validation tests ─────────────────────────────────

    #[test]
    fn test_section_ordering() {
        // WASM spec requires sections in ascending ID order.
        // Build a module with multiple sections and verify.
        let mut module = WasmModule::new();
        module.types.push(FuncType {
            params: vec![],
            results: vec![ValType::I32],
        });
        module.functions.push(0);
        module.memories.push(MemoryType { min: 1, max: None });
        module.exports.push(Export {
            name: "_start".to_string(),
            kind: ExportKind::Func,
            index: 0,
        });
        let mut code = Vec::new();
        code.push(Op::I32Const as u8);
        encode_sleb128(0, &mut code);
        module.codes.push(FuncBody {
            locals: vec![],
            code,
        });

        let bytes = module.encode();
        // Walk sections and verify IDs are non-decreasing
        let mut pos = 8; // skip header
        let mut last_id = 0u8;
        while pos < bytes.len() {
            let section_id = bytes[pos];
            assert!(
                section_id >= last_id,
                "Section ID {} came after {}, violating WASM ordering",
                section_id,
                last_id
            );
            last_id = section_id;
            pos += 1;
            // Read section size (LEB128)
            let (size, consumed) = decode_uleb128_for_test(&bytes[pos..]);
            pos += consumed;
            pos += size as usize; // skip section body
        }
        assert_eq!(pos, bytes.len(), "binary should be fully consumed");
    }

    #[test]
    fn test_type_section_structure() {
        let mut module = WasmModule::new();
        // (i32, i32) -> i32
        module.types.push(FuncType {
            params: vec![ValType::I32, ValType::I32],
            results: vec![ValType::I32],
        });
        module.functions.push(0);
        let mut code = Vec::new();
        code.push(Op::LocalGet as u8);
        encode_uleb128(0, &mut code);
        module.codes.push(FuncBody {
            locals: vec![],
            code,
        });

        let bytes = module.encode();
        // Find type section (ID=1)
        let (section_body, _) = find_section(&bytes, SectionId::Type as u8);
        // First byte is count (1 type)
        assert_eq!(section_body[0], 1, "should have exactly 1 type");
        // Next byte is 0x60 (func type marker)
        assert_eq!(section_body[1], 0x60, "should start with func type marker");
    }

    #[test]
    fn test_export_section_contains_start() {
        let mut module = WasmModule::new();
        module.types.push(FuncType {
            params: vec![],
            results: vec![ValType::I32],
        });
        module.functions.push(0);
        module.exports.push(Export {
            name: "_start".to_string(),
            kind: ExportKind::Func,
            index: 0,
        });
        let mut code = Vec::new();
        code.push(Op::I32Const as u8);
        encode_sleb128(42, &mut code);
        module.codes.push(FuncBody {
            locals: vec![],
            code,
        });

        let bytes = module.encode();
        // Verify export section exists and contains "_start"
        let (section_body, _) = find_section(&bytes, SectionId::Export as u8);
        // Export count
        assert_eq!(section_body[0], 1);
        // Export name length
        assert_eq!(section_body[1], 6); // "_start" = 6 bytes
                                        // Export name
        assert_eq!(&section_body[2..8], b"_start");
    }

    #[test]
    fn test_code_section_contains_i32_const_42() {
        let mut module = WasmModule::new();
        module.types.push(FuncType {
            params: vec![],
            results: vec![ValType::I32],
        });
        module.functions.push(0);
        let mut code = Vec::new();
        code.push(Op::I32Const as u8);
        encode_sleb128(42, &mut code);
        module.codes.push(FuncBody {
            locals: vec![],
            code,
        });

        let bytes = module.encode();
        // Find code section
        let (section_body, _) = find_section(&bytes, SectionId::Code as u8);
        // The section should contain the i32.const 42 opcode sequence
        let has_const_42 = section_body
            .windows(2)
            .any(|w| w[0] == Op::I32Const as u8 && w[1] == 42);
        assert!(has_const_42, "code section should contain i32.const 42");
    }

    #[test]
    fn test_empty_module_is_valid() {
        let module = WasmModule::new();
        let bytes = module.encode();
        // Empty module = just header (8 bytes)
        assert_eq!(bytes.len(), 8);
        assert_eq!(&bytes[0..4], &WASM_MAGIC);
        assert_eq!(&bytes[4..8], &WASM_VERSION);
    }

    #[test]
    fn test_memory_section_one_page() {
        let mut module = WasmModule::new();
        module.memories.push(MemoryType {
            min: 1,
            max: Some(256),
        });
        let bytes = module.encode();
        let (section_body, _) = find_section(&bytes, SectionId::Memory as u8);
        // Count = 1
        assert_eq!(section_body[0], 1);
        // Has max flag = 0x01
        assert_eq!(section_body[1], 0x01);
        // Min = 1
        assert_eq!(section_body[2], 1);
    }

    // ─── Test helpers ────────────────────────────────────────────────

    /// Decode a ULEB128 value for test assertions. Returns (value, bytes_consumed).
    fn decode_uleb128_for_test(bytes: &[u8]) -> (u64, usize) {
        let mut result: u64 = 0;
        let mut shift = 0;
        for (i, &byte) in bytes.iter().enumerate() {
            result |= ((byte & 0x7F) as u64) << shift;
            shift += 7;
            if byte & 0x80 == 0 {
                return (result, i + 1);
            }
        }
        (result, bytes.len())
    }

    /// Find a section by ID in a WASM binary. Returns (section_body, start_offset).
    fn find_section(bytes: &[u8], section_id: u8) -> (&[u8], usize) {
        let mut pos = 8; // skip header
        while pos < bytes.len() {
            let id = bytes[pos];
            pos += 1;
            let (size, consumed) = decode_uleb128_for_test(&bytes[pos..]);
            pos += consumed;
            if id == section_id {
                return (&bytes[pos..pos + size as usize], pos);
            }
            pos += size as usize;
        }
        panic!("Section {} not found in WASM binary", section_id);
    }
}
