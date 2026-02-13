# Task #4: XSS Prevention — Enhanced Implementation Plan

**Current Status:** Basic XSS infrastructure exists from Task #3
**Goal:** Full context-aware XSS prevention matching XSSPrevention.v (170 Qed proofs)

---

## Gap Analysis

### ✅ Already Implemented (Task #3)
- `sanitize_html` : Tainted → Sanitized<HtmlEscape>
- `sanitize_js` : Tainted → Sanitized<JsEscape>
- `html_render` : Requires Sanitized<HtmlEscape>
- `js_eval` : Requires Sanitized<JsEscape>
- Basic type checking for XSS prevention
- 1 XSS prevention test

### ❌ Missing (To Implement Now)
1. **Context-Aware Sanitization** (5 contexts from Coq)
   - HTML context sanitization
   - Attribute context sanitization
   - Script context sanitization
   - CSS context sanitization
   - URL context sanitization

2. **DOM-Based XSS Prevention**
   - DOM sanitizer builtins
   - Safe DOM manipulation functions
   - Event handler sanitization

3. **Content Security Policy (CSP)**
   - CSP type for header configuration
   - Nonce generation
   - Script/style source restrictions

4. **Input Validation**
   - Length bounds checking
   - Unicode normalization
   - Null byte stripping

5. **XSS Attack Type Coverage**
   - Reflected XSS prevention
   - Stored XSS prevention
   - DOM-based XSS prevention

---

## Implementation Steps

### Step 1: Add Context-Specific Types

```rust
// In riina-types/src/lib.rs — add new enum

/// XSS output context (matches Coq XSSContext)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum XSSContext {
    /// HTML body content
    HTML,
    /// HTML attribute value
    Attribute,
    /// JavaScript code
    Script,
    /// CSS style
    CSS,
    /// URL parameter
    URL,
}

/// Context-aware sanitized type
/// Sanitized<String, (HtmlEscape, XSSContext::HTML)>
```

### Step 2: Add Context-Aware Sanitizers

```rust
// In riina-typechecker/src/lib.rs — register_builtin_types()

// HTML context
c = c.extend("sanitize_html_body".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::HtmlEscape)),
        Effect::Pure
    ));

// Attribute context (different escaping rules!)
c = c.extend("sanitize_html_attr".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::HtmlEscape)),
        Effect::Pure
    ));

// URL context
c = c.extend("sanitize_url".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::UrlEncode)),
        Effect::Pure
    ));

// CSS context
c = c.extend("sanitize_css".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::CssEscape)),
        Effect::Pure
    ));
```

### Step 3: Add DOM Sanitization Builtins

```rust
// DOM manipulation — requires sanitized input

// Safe innerHTML setter
c = c.extend("dom_set_html".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Any),  // DOM element
            Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::HtmlEscape))
        )),
        Box::new(Ty::Unit),
        Effect::System
    ));

// Safe attribute setter
c = c.extend("dom_set_attr".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Any),  // DOM element
            Box::new(Ty::Prod(
                Box::new(Ty::String),  // Attribute name
                Box::new(Ty::Sanitized(Box::new(Ty::String), Sanitizer::HtmlEscape))
            ))
        )),
        Box::new(Ty::Unit),
        Effect::System
    ));

// Safe event handler attachment
c = c.extend("dom_add_event".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Any),  // DOM element
            Box::new(Ty::Prod(
                Box::new(Ty::String),  // Event name
                Box::new(Ty::Fn(Box::new(Ty::Any), Box::new(Ty::Unit), Effect::Pure))  // Handler
            ))
        )),
        Box::new(Ty::Unit),
        Effect::System
    ));
```

### Step 4: Add CSP Type and Builtins

```rust
// In riina-types/src/lib.rs

/// Content Security Policy configuration
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum CSPDirective {
    ScriptSrc(Vec<String>),
    StyleSrc(Vec<String>),
    DefaultSrc(Vec<String>),
    FrameAncestors(Vec<String>),
}

pub struct CSPConfig {
    pub directives: Vec<CSPDirective>,
    pub nonce: Option<String>,
    pub strict_dynamic: bool,
}
```

```rust
// In riina-typechecker

// CSP nonce generation
c = c.extend("csp_nonce".to_string(),
    Ty::Fn(
        Box::new(Ty::Unit),
        Box::new(Ty::String),  // Cryptographic nonce
        Effect::Random
    ));

// CSP header building
c = c.extend("csp_build".to_string(),
    Ty::Fn(
        Box::new(Ty::Any),  // CSPConfig
        Box::new(Ty::String),  // CSP header value
        Effect::Pure
    ));
```

### Step 5: Add Input Validation Builtins

```rust
// Length-bounded input
c = c.extend("validate_length".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
            Box::new(Ty::Int)  // Max length
        )),
        Box::new(Ty::Option(Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)))),
        Effect::Pure
    ));

// Unicode normalization
c = c.extend("normalize_unicode".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Effect::Pure
    ));

// Strip null bytes
c = c.extend("strip_nulls".to_string(),
    Ty::Fn(
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Box::new(Ty::Tainted(Box::new(Ty::String), TaintSource::UserInput)),
        Effect::Pure
    ));
```

---

## Test Coverage

### New Tests to Add

1. **test_xss_html_context** — HTML body sanitization
2. **test_xss_attribute_context** — HTML attribute sanitization
3. **test_xss_script_context** — JavaScript context sanitization
4. **test_xss_css_context** — CSS context sanitization
5. **test_xss_url_context** — URL parameter sanitization
6. **test_xss_dom_set_html** — Safe DOM manipulation
7. **test_xss_dom_set_attr** — Safe attribute setting
8. **test_xss_reflected** — Reflected XSS prevention
9. **test_xss_stored** — Stored XSS prevention
10. **test_xss_dom_based** — DOM-based XSS prevention
11. **test_xss_input_validation** — Input length/normalization
12. **test_xss_context_mismatch** — Wrong context sanitizer rejected

---

## Example: Context-Aware XSS Prevention

**Safe HTML Body:**
```riina
fungsi render_comment(comment: Tainted<String, UserInput>) -> Html {
    biar safe = sanitize_html_body(comment);  // HTML context
    html_render(safe)
}
```

**Safe HTML Attribute:**
```riina
fungsi render_title(title: Tainted<String, UserInput>) -> Attr {
    biar safe = sanitize_html_attr(title);  // Attribute context (different rules!)
    attr_render("title", safe)
}
```

**Safe URL Parameter:**
```riina
fungsi redirect(url: Tainted<String, UserInput>) -> () {
    biar safe = sanitize_url(url);  // URL context
    http_redirect(safe)
}
```

**Context Mismatch Rejected:**
```riina
fungsi bahaya(comment: Tainted<String, UserInput>) {
    biar safe_url = sanitize_url(comment);  // URL sanitizer
    html_render(safe_url);  // TYPE ERROR: expected HtmlEscape, found UrlEncode
}
```

---

## Coq Alignment

All implementation matches XSSPrevention.v:

| Coq Type | Rust Type | Status |
|----------|-----------|--------|
| `XSSContext` | `XSSContext` enum | To implement |
| `OutputEncoding` | Context-specific `Sanitizer` variants | Partial |
| `ContentSecurityPolicy` | `CSPConfig` struct | To implement |
| `DOMSanitizer` | DOM builtins | To implement |
| `InputValidator` | Validation builtins | To implement |
| `TaintedString` | `Tainted<String, Source>` | ✅ Exists |
| `riina_xss` config | Builtin defaults | To implement |

---

## Success Criteria

- [ ] 5 context-specific sanitizers (HTML, Attr, Script, CSS, URL)
- [ ] 3 DOM manipulation builtins (set_html, set_attr, add_event)
- [ ] 2 CSP builtins (nonce, build)
- [ ] 3 input validation builtins (length, normalize, strip_nulls)
- [ ] 12 new XSS tests (all passing)
- [ ] Context mismatch detection (e.g., URL sanitizer for HTML → error)
- [ ] All 170 XSS theorems from Coq aligned with type enforcement

---

**Next Action:** Implement Step 1 (context-specific types)
