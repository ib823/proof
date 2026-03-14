# κ-01: Verified Full-Stack Security — End-to-End Web Application Proofs

**Domain:** κ — Verified Full-Stack Security
**Status:** Research Complete
**Date:** 2026-03-14
**RIINA Feature Target:** Verified compilation to JS/WASM, session types for web protocols, end-to-end information flow, XSS/CSRF elimination by construction

---

## 1. Problem Statement

Web applications span multiple trust boundaries: client-side code runs in an untrusted browser, server-side code processes requests from untrusted clients, and databases store data accessed by multiple components. Each boundary is a potential vulnerability. The OWASP Top 10 — injection, broken authentication, XSS, CSRF — persists decade after decade because web security is addressed at each layer independently, with no end-to-end guarantees.

Traditional approaches to web security rely on sanitization, input validation, and content security policies — all of which are error-prone and incomplete. A single missed sanitization point creates a vulnerability. RIINA addresses this by providing verified full-stack security: the type system enforces security properties across client, server, and database boundaries, eliminating entire vulnerability classes by construction rather than by convention.

## 2. State of the Art

### 2.1 Ur/Web

Ur/Web is a domain-specific language for web programming that prevents code injection, XSS, and CSRF by construction through its type system. The compiler generates JavaScript for the client and native code for the server, with the type system enforcing security properties across the boundary.

Chlipala, A., "Ur/Web: A Simple Model for Programming the Web", *POPL*, 2015.

### 2.2 SELinks and Secure Multi-Tier Programming

SELinks extends the Links web programming language with security labels, enforcing information flow policies across client-server boundaries. The type system tracks data provenance and prevents unauthorized data flows between tiers.

Corcoran, B. J., Swamy, N., Hicks, M., "Cross-Tier, Label-Based Security Enforcement for Web Applications", *SIGMOD*, 2009.

### 2.3 Jif: Java Information Flow

Jif extends Java with security labels for information flow control. It has been applied to web applications to enforce confidentiality and integrity policies across client-server interactions, preventing information leakage through both explicit and implicit flows.

Myers, A. C., "JFlow: Practical Mostly-Static Information Flow Control", *POPL*, 1999.

### 2.4 OWASP and Web Vulnerability Taxonomy

The OWASP Foundation maintains the authoritative taxonomy of web application vulnerabilities. The Top 10 list has remained remarkably stable, indicating that fundamental vulnerability classes (injection, XSS, CSRF) are not being addressed by existing tools and practices.

OWASP Foundation, "OWASP Top Ten Web Application Security Risks", 2021.

### 2.5 Hop and Multi-Tier Web Programming

Hop pioneered multi-tier web programming where client and server code are written in a single language with the compiler handling the distribution. This approach eliminates serialization bugs and ensures type safety across the client-server boundary.

Serrano, M., Queinnec, C., "A Multi-Tier Semantics for Hop", *Higher-Order and Symbolic Computation*, 23(4):409-431, 2010.

### 2.6 Featherweight Firefox

Bohannon et al. developed Featherweight Firefox, a formal model of browser security mechanisms including the same-origin policy, cookie policies, and DOM access control. The model enables formal verification of browser security properties and identification of policy inconsistencies.

Bohannon, A., Pierce, B. C., Sjöberg, V., Weirich, S., Zdancewic, S., "Reactive Noninterference", *CCS*, 2009.

### 2.7 F* for Verified Web Protocols

F* has been used to verify web security protocols including TLS, HTTPS, and authentication flows. The combination of dependent types and effects enables specification and verification of complex security properties across protocol boundaries.

Swamy, N., Hriţcu, C., Keller, C., Rastogi, A., Delignat-Lavaud, A., Forest, S., Bhargavan, K., Fournet, C., Strub, P.-Y., Kohlweiss, M., Zinzindohoué, J.-K., Zanella-Béguelin, S., "Dependent Types and Multi-Monadic Effects in F*", *POPL*, 2016.

### 2.8 WebAssembly Security

WebAssembly provides a sandboxed execution environment for client-side code with formally defined semantics. Its type system ensures memory safety and control flow integrity, providing a verified compilation target for security-critical web applications.

Haas, A., Rossberg, A., Schuff, D. L., Titzer, B. L., Holman, M., Gohman, D., Wagner, L., Zakai, A., Bastien, J. F., "Bringing the Web up to Speed with WebAssembly", *PLDI*, 2017.

## 3. Properties Verifiable by RIINA

| Property | Method | RIINA Mechanism |
|----------|--------|-----------------|
| XSS elimination | Type-level content escaping | Untrusted strings cannot appear in HTML contexts |
| CSRF prevention | Session type enforcement | State-changing operations require valid tokens |
| SQL injection prevention | Parameterized query types | Queries constructed only through typed API |
| Information flow across tiers | Security label propagation | Labels tracked from database to client |
| Authentication correctness | Session type state machine | Login/logout protocol verified by types |
| WASM compilation correctness | Translation validation | Compiled WASM semantically equivalent to source |

## 4. RIINA Integration Architecture

### 4.1 Multi-Tier Security Types

```riina
// Verified web handler with security labels
@pelayan(laluan: "/api/data")
fungsi ambil_data(sesi: Sesi<Disahkan>, pertanyaan: Teks)
    -> Hasil<HtmlSelamat, RalatWeb>
    kesan Web<TiadaXSS, TiadaCSRF>
{
    // Type system prevents raw string interpolation into HTML
    biar data = pangkalan_data.pertanyaan_selamat(pertanyaan);
    biar html = templat::render("data.html", data);
    pulang Ok(html);
}
```

### 4.2 Coq Formalization

```coq
(* XSS elimination: sanitized content cannot contain scripts *)
Theorem xss_free : forall input output,
  sanitize input = output ->
  ~ contains_script output.

(* Cross-tier information flow: secret data stays on server *)
Theorem server_confinement : forall data label response,
  security_label data = Secret ->
  generate_response data = response ->
  no_secret_in_client response.
```

## 5. Key References

| Reference | Venue | Contribution |
|-----------|-------|--------------|
| Chlipala, A., "Ur/Web" (2015) | POPL | Type-safe web programming |
| Corcoran, B. J., et al., "SELinks" (2009) | SIGMOD | Cross-tier security labels |
| Myers, A. C., "JFlow" (1999) | POPL | Information flow for Java |
| Serrano, M., Queinnec, C., "Hop" (2010) | HOSC | Multi-tier web semantics |
| Bohannon, A., et al., "Reactive Noninterference" (2009) | CCS | Browser security formalization |
| Swamy, N., et al., "F*" (2016) | POPL | Dependent types for verification |
| Haas, A., et al., "WebAssembly" (2017) | PLDI | Verified compilation target |
| OWASP Foundation, "Top Ten" (2021) | OWASP | Web vulnerability taxonomy |

## 6. Formalizability Assessment

| Component | Effort (person-months) | Feasibility | Phase |
|-----------|----------------------|-------------|-------|
| XSS-free type system | 3-4 | High — Ur/Web methodology | Phase 1 |
| SQL injection prevention types | 2-3 | High — parameterized queries | Phase 1 |
| CSRF token state machine | 2-3 | High — session types | Phase 2 |
| Cross-tier information flow | 4-6 | Medium — label propagation | Phase 2 |
| WASM compilation verification | 6-8 | Medium — translation validation | Phase 3 |
| End-to-end web security proof | 6-8 | Low-Medium — composition across tiers | Phase 4 |

## 7. Scope Limitations

1. **Browser as TCB.** RIINA cannot verify the browser itself. Vulnerabilities in the browser engine bypass all application-level guarantees.
2. **Third-party JavaScript.** Most web applications include third-party scripts (analytics, ads) that are outside RIINA's verification boundary.
3. **DOM complexity.** The browser DOM has enormous API surface. Formalizing all DOM interactions is impractical; RIINA provides a verified subset.
4. **Performance.** Verified compilation to WASM may produce less optimized code than hand-tuned JavaScript, affecting user experience.
5. **Ecosystem integration.** Web development relies on extensive npm/package ecosystems. Verified components cannot use unverified libraries without trust boundaries.
6. **Server-side state.** Database interactions, caching, and distributed state introduce complexity beyond the type system's reach.

---

*"If the type system prevents injection, injection cannot happen."*
