# RIINA

**核心模型经 Coq 验证的编程语言。**

核心类型与效果规则已在 Coq 中针对语言模型得到证明；编译器则依照该模型进行测试。

---

## 什么是 RIINA？

RIINA 是一种**核心模型经 Coq 验证**的编程语言。能够编译通过的程序，即通过了编译器所实现的类型与效果检查。Coq 是唯一完全机械化的证明通道；当前数据见 [README](../../README.md) 与 `website/public/metrics.json`。

**与 CompCert 或 CakeML 不同，编译器 `riinac` 本身并未经过形式化验证。** 在 Coq 中证明的是语言模型（见下表）；编译器依照该模型进行测试，而非被证明实现了该模型。

| 语言模型中的属性 | 状态 |
|---|---|
| 安全级别间无信息泄露 | 非干扰性已在 Coq 中针对无引用、无递归的核心得到证明；超出该核心的部分由测试保障 |
| 无未授权副作用执行 | 效果门代数与效果可靠性已在 Coq 模型中证明；编译器强制执行所声明的效果 |
| 类型安全（无运行时类型错误） | 进展 + 保持定理 (Coq)；编译器的类型检查器依照该模型进行测试 |
| 公开输出中无秘密数据 | 降密（解除保密）模型 (Coq)；编译器的对齐工作仍在进行中 |
| 终止性（仅限无引用、无 `fix` 的核心） | 强归一化已在 Coq 中针对该核心证明 |
| 无垃圾回收的内存安全 | 仅为分离逻辑模型 (Coq)——并非对所发布编译器的证明 |

---

## 快速开始

### 安装

```bash
git clone https://github.com/ib823/riina.git
cd riina/03_PROTO
cargo build --release
```

编译器二进制文件为 `riinac`。所发布的编译器在运行时零外部依赖。开发与 CI 使用另外的工具：Rocq 工具链、`cc`、`wasmtime`、`z3`、模糊测试（fuzz）工具以及 NIST 测试向量。

### Hello World

创建 `hello.rii`：

```riina
fungsi utama() -> Teks kesan Tulis {
    biar mesej = "Selamat datang ke RIINA!";
    cetak(mesej);          // 'cetak' 用于打印；其效果为 'Tulis'（写）
    mesej                  // 末尾表达式即返回值（无需 'pulang;'）
}
```

```bash
riinac check hello.rii    # 类型检查和验证
riinac run hello.rii      # 直接运行
riinac build hello.rii    # 通过 C 编译为本地二进制文件
```

### 安全示例

```riina
fungsi proses_pembayaran(kad: Rahsia<Teks>, jumlah: Nombor) -> Teks kesan Kripto {
    biar cap = cincang(kad);                      // 正确：秘密的哈希值仍是秘密
    biar resit = "Jumlah: " + ke_teks(jumlah);    // 正确：金额是公开的
    resit                                         // 正确：只返回公开数据
}
```

```riina error="Security violation in print sink"
fungsi utama() -> Unit kesan Tulis {
    biar kad = sulit "4111 1111 1111 1111";
    cetakln(kad)                                  // 编译错误：秘密到达打印输出
}
```

以上两段代码均由测试（`03_PROTO/crates/riinac/tests/doc_snippets.rs`）检查：第一段通过，第二段被检查器拒绝。

- **密码学仍属实验性：** RIINA 自研的密码库（`riina-core`）仍属实验性，未经审计——目前请勿用它保护真实的机密。尚未发布任何独立审计。
- **按设计不支持浮点数：** 浮点字面量是编译错误（P0015）。精确的整数与定点运算使程序保持在证明所建模的范围之内。

---

## 关键字参考

RIINA 使用**马来语**关键字。以下是对照表：

| RIINA (马来语) | 中文 | 英文 | 示例 |
|-------|------|------|------|
| `fungsi` | 函数 | fn | `fungsi tambah(x: Nombor) -> Nombor` |
| `biar` | 让 | let | `biar nama = "Ahmad";` |
| `kalau` | 如果 | if | `kalau x > 0 { ... }` |
| `lain` | 否则 | else | `lain { ... }` |
| `untuk` | 循环 | for | `untuk x dalam senarai { ... }` |
| `pulang` | 返回 | return | `pulang hasil;` |
| `padan` | 匹配 | match | `padan nilai { ... }` |
| `rahsia` | 秘密 | secret | `biar kunci: Rahsia<Teks>` |
| `dedah` | 降密 | declassify | `dedah(nilai)` |
| `kesan` | 效果 | effect | `kesan Tulis` |
| `bersih` | 纯 | pure | `kesan Bersih` |
| `betul` / `salah` | 真 / 假 | true / false | 布尔值 |

---

## 贡献

参见 [CONTRIBUTING.md](../../CONTRIBUTING.md) 了解贡献指南。

## 许可证

[RIINA Proprietary License](../../LICENSE)

---

*RIINA — Rigorous Immutable Invariant, No Assumptions*

*Q.E.D. Aeternum.*
