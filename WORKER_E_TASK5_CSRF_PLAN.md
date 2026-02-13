# Task #5: CSRF Protection — Implementation Plan

**Current Status:** Tasks #3-#4 complete
**Goal:** Compiler-enforced CSRF protection matching CSRFProtection.v (20 Qed proofs)

---

## Gap Analysis

### ✅ Foundation from Tasks #3-#4
- Taint tracking infrastructure
- Type-level security enforcement
- Context-aware sanitization
- Test coverage patterns

### ❌ Missing (To Implement Now)
1. **CSRF Token Types** — cryptographic tokens that can't be forged
2. **State-Changing Request Protection** — POST/PUT/DELETE require tokens
3. **Origin Validation** — same-origin policy enforcement
4. **Double-Submit Pattern** — token in cookie + request body
5. **Same-Site Cookie Enforcement** — cookie attributes

---

## Coq Specification Analysis

From `CSRFProtection.v`:

```coq
Record CSRFConfig : Type := mkCSRF {
  csrf_token_validation : bool;       (* Validate token on state-changing requests *)
  csrf_same_site_cookies : bool;      (* SameSite cookie attribute *)
  csrf_origin_check : bool;           (* Validate Origin header *)
  csrf_referer_check : bool;          (* Validate Referer header *)
  csrf_double_submit : bool;          (* Token in both cookie and body *)
}.

Definition csrf_protected (c : CSRFConfig) : bool :=
  csrf_token_validation c && csrf_same_site_cookies c && csrf_origin_check c &&
  csrf_referer_check c && csrf_double_submit c.
```

**Key Insight:** All 5 protections must be enabled for full CSRF protection.

---

## Type System Design

### 1. CSRF Token Types

```rust
// In riina-types/src/lib.rs

/// CSRF token (cryptographically secure, unforgeable)
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct CSRFToken {
    pub token: String,  // Base64-encoded random bytes
    pub origin: String, // Expected origin
}

/// HTTP method categories
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum HttpMethod {
    GET,      // Safe method (no CSRF token needed)
    HEAD,     // Safe method
    OPTIONS,  // Safe method
    POST,     // State-changing (CSRF token REQUIRED)
    PUT,      // State-changing (CSRF token REQUIRED)
    DELETE,   // State-changing (CSRF token REQUIRED)
    PATCH,    // State-changing (CSRF token REQUIRED)
}

impl HttpMethod {
    pub fn is_safe(&self) -> bool {
        matches!(self, HttpMethod::GET | HttpMethod::HEAD | HttpMethod::OPTIONS)
    }
}
```

### 2. Request Types

```rust
// In riina-types/src/ty.rs

pub enum Ty {
    // ... existing variants ...

    /// HTTP request with CSRF protection
    HttpRequest {
        method: HttpMethod,
        has_csrf_token: bool,
        origin: Option<String>,
    },

    /// CSRF-protected session
    Session {
        csrf_token: Option<CSRFToken>,
    },
}
```

### 3. Type Rules

**Rule 1: State-changing requests require CSRF tokens**
```
POST/PUT/DELETE/PATCH request → must have has_csrf_token = true
```

**Rule 2: CSRF token generation returns secure token**
```
csrf_generate() : () → CSRFToken
```

**Rule 3: Request validation requires token**
```
csrf_validate(request: HttpRequest, token: CSRFToken) → Result<(), CSRFError>
```

---

## Implementation Steps

### Step 1: Add CSRF Types to riina-types

```rust
// In riina-types/src/lib.rs

/// CSRF protection primitives
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct CSRFToken(pub String);

#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum HttpMethod {
    GET, HEAD, OPTIONS,  // Safe
    POST, PUT, DELETE, PATCH,  // State-changing
}

impl HttpMethod {
    pub fn is_safe(&self) -> bool {
        matches!(self, HttpMethod::GET | HttpMethod::HEAD | HttpMethod::OPTIONS)
    }
}
```

### Step 2: Add CSRF Builtins to Typechecker

```rust
// In riina-typechecker/src/lib.rs — register_builtin_types()

// ── CSRF PROTECTION ──

// Generate CSRF token (cryptographically secure)
c = c.extend("csrf_generate".to_string(),
    Ty::Fn(
        Box::new(Ty::Unit),
        Box::new(Ty::Any),  // CSRFToken (opaque)
        Effect::Random  // Cryptographic randomness
    ));
c = c.extend("csrf_jana".to_string(),
    Ty::Fn(
        Box::new(Ty::Unit),
        Box::new(Ty::Any),
        Effect::Random
    ));

// Validate CSRF token (returns bool)
c = c.extend("csrf_validate".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Any),  // Request
            Box::new(Ty::Any)   // CSRF token
        )),
        Box::new(Ty::Bool),  // Validation result
        Effect::Pure
    ));
c = c.extend("csrf_sahkan".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::Any),
            Box::new(Ty::Any)
        )),
        Box::new(Ty::Bool),
        Effect::Pure
    ));

// Check origin header
c = c.extend("csrf_check_origin".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::String),  // Request Origin
            Box::new(Ty::String)   // Expected Origin
        )),
        Box::new(Ty::Bool),
        Effect::Pure
    ));
c = c.extend("csrf_semak_origin".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::String),
            Box::new(Ty::String)
        )),
        Box::new(Ty::Bool),
        Effect::Pure
    ));

// State-changing request handlers (require CSRF token)
c = c.extend("http_post".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::String),  // URL
            Box::new(Ty::Prod(
                Box::new(Ty::Any),  // Request body
                Box::new(Ty::Any)   // CSRF token (REQUIRED)
            ))
        )),
        Box::new(Ty::Any),  // Response
        Effect::Network
    ));
c = c.extend("http_hantar".to_string(),
    Ty::Fn(
        Box::new(Ty::Prod(
            Box::new(Ty::String),
            Box::new(Ty::Prod(
                Box::new(Ty::Any),
                Box::new(Ty::Any)
            ))
        )),
        Box::new(Ty::Any),
        Effect::Network
    ));

// Safe GET request (no CSRF token needed)
c = c.extend("http_get".to_string(),
    Ty::Fn(
        Box::new(Ty::String),  // URL (no token required)
        Box::new(Ty::Any),
        Effect::Network
    ));
c = c.extend("http_dapat".to_string(),
    Ty::Fn(
        Box::new(Ty::String),
        Box::new(Ty::Any),
        Effect::Network
    ));
```

### Step 3: Add CSRF Error Types

```rust
// In riina-typechecker/src/lib.rs — TypeError enum

pub enum TypeError {
    // ... existing variants ...

    /// State-changing HTTP request without CSRF token
    /// Matches Coq CSRFProtection.v (csrf_token_validation)
    CSRFTokenMissing {
        method: &'static str,  // "POST", "PUT", "DELETE", "PATCH"
        context: &'static str,
    },

    /// Origin mismatch (potential CSRF attack)
    /// Matches Coq CSRFProtection.v (csrf_origin_check)
    CSRFOriginMismatch {
        expected: String,
        found: String,
    },
}
```

---

## Test Coverage

### Tests to Add

1. **test_csrf_token_generation** — csrf_generate returns token
2. **test_csrf_post_requires_token** — http_post requires CSRF token parameter
3. **test_csrf_get_no_token** — http_get does NOT require token (safe method)
4. **test_csrf_put_requires_token** — http_put requires token
5. **test_csrf_delete_requires_token** — http_delete requires token
6. **test_csrf_origin_check** — csrf_check_origin validates origin
7. **test_csrf_origin_mismatch** — origin check rejects mismatched origin
8. **test_csrf_double_submit** — token in both cookie and body
9. **test_csrf_replay_attack_prevented** — old token rejected
10. **test_csrf_missing_token_rejected** — POST without token fails

---

## Example: CSRF-Protected Request

**Safe GET (no token needed):**
```riina
fungsi fetch_data(url: Teks) -> Hasil {
    http_get(url)  // Safe method, no CSRF token
}
```

**State-Changing POST (token REQUIRED):**
```riina
fungsi submit_form(data: Any, token: CSRFToken) -> Hasil {
    http_post("https://example.com/api", (data, token))
}
```

**Missing Token (TYPE ERROR):**
```riina
fungsi bahaya(data: Any) -> Hasil {
    http_post("https://example.com/api", data)
    // TYPE ERROR: expected (String, (Any, CSRFToken)), found (String, Any)
    // CSRF token missing for state-changing request!
}
```

**Origin Validation:**
```riina
fungsi validate_request(req_origin: Teks, token: CSRFToken) -> Bool {
    biar expected = "https://example.com";
    kalau csrf_check_origin(req_origin, expected) {
        csrf_validate(request, token)
    } lain {
        salah  // Origin mismatch, reject
    }
}
```

---

## Coq Alignment

| Coq Property | Rust Implementation | Status |
|--------------|---------------------|--------|
| `csrf_token_validation` | `http_post` requires CSRFToken | To implement |
| `csrf_same_site_cookies` | Cookie configuration (runtime) | To implement |
| `csrf_origin_check` | `csrf_check_origin` builtin | To implement |
| `csrf_referer_check` | Similar to origin check | To implement |
| `csrf_double_submit` | Token in (body, cookie) pair | To implement |
| `csrf_protected` | All 5 checks enabled | To implement |

**Theorem Alignment:**
- CSRF_001-005: Default config has all protections
- CSRF_006-010: Each protection can be extracted
- CSRF_011-020: Combinations of protections

---

## Success Criteria

- [ ] 8 CSRF builtins (4 BM/EN pairs)
- [ ] 2 new TypeError variants (CSRFTokenMissing, CSRFOriginMismatch)
- [ ] 10 comprehensive tests (all passing)
- [ ] GET/HEAD/OPTIONS don't require token (safe methods)
- [ ] POST/PUT/DELETE/PATCH require token (state-changing)
- [ ] Origin validation enforced
- [ ] All 20 CSRF theorems from Coq aligned

---

**Next Action:** Implement Step 1 (add CSRF types to riina-types)
