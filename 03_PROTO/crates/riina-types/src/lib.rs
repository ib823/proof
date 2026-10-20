// Copyright (c) 2026 The RIINA Authors. All rights reserved.

//! RIINA Types (AST)
//!
//! Abstract Syntax Tree definitions corresponding to the formal Coq specification.
//! RIINA = Rigorous Immutable Invariant, No Assumptions
//!
//! Reference: `02_FORMAL/coq/foundations/Syntax.v`
//!
//! Mode: ULTRA KIASU | FUCKING PARANOID | ZERO TRUST | ZERO LAZINESS

pub mod persistent;

/// Identifiers are strings.
pub type Ident = String;

/// Security Levels
///
/// RIINA uses a multi-level lattice for information flow control.
/// Matches Coq `security_level` in `foundations/Syntax.v`.
///
/// Lattice: Public ⊑ Internal ⊑ Session ⊑ User ⊑ System ⊑ Secret
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum SecurityLevel {
    /// Publicly observable
    Public,
    /// Internal use only
    Internal,
    /// Session-scoped
    Session,
    /// User-level sensitive
    User,
    /// System-level sensitive
    System,
    /// Maximum secrecy
    Secret,
}

impl SecurityLevel {
    /// Numeric encoding matching Coq `sec_level_num`
    #[must_use]
    pub const fn level(self) -> u8 {
        match self {
            Self::Public => 0,
            Self::Internal => 1,
            Self::Session => 2,
            Self::User => 3,
            Self::System => 4,
            Self::Secret => 5,
        }
    }

    /// Ordering: l1 ⊑ l2
    #[must_use]
    pub const fn leq(self, other: Self) -> bool {
        self.level() <= other.level()
    }

    /// Join (least upper bound)
    #[must_use]
    pub const fn join(self, other: Self) -> Self {
        if self.level() <= other.level() {
            other
        } else {
            self
        }
    }

    /// Meet (greatest lower bound)
    #[must_use]
    pub const fn meet(self, other: Self) -> Self {
        if self.level() <= other.level() {
            self
        } else {
            other
        }
    }

    /// Convert from numeric level back to SecurityLevel.
    #[must_use]
    pub const fn from_level(n: u8) -> Self {
        match n {
            0 => Self::Public,
            1 => Self::Internal,
            2 => Self::Session,
            3 => Self::User,
            4 => Self::System,
            _ => Self::Secret,
        }
    }
}

/// Linearity qualifiers for substructural type system.
///
/// Matches Coq `Linearity` in `domains/LinearTypes.v`.
/// Controls how many times a variable binding may be used.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Linearity {
    /// Linear: must be used exactly once
    Linear,
    /// Affine: may be used at most once (can be dropped)
    Affine,
    /// Relevant: must be used at least once (can be duplicated)
    Relevant,
    /// Unrestricted: no usage constraints (default)
    Unrestricted,
}

/// Usage count for linearity tracking.
///
/// Matches Coq `Usage` in `domains/LinearTypes.v`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Usage {
    /// Not yet used
    Zero,
    /// Used exactly once
    One,
    /// Used more than once
    Many,
}

impl Usage {
    /// Increment usage: Zero→One, One→Many, Many→Many
    #[must_use]
    pub const fn increment(self) -> Self {
        match self {
            Usage::Zero => Usage::One,
            Usage::One => Usage::Many,
            Usage::Many => Usage::Many,
        }
    }
}

/// Effects
///
/// Effects track observable behaviors of computations.
/// Coq `effect` in `foundations/Syntax.v` has every variant except `Mut` and
/// `Alloc`; `docs/spec/CORE_MAPPING.md` maps each one.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum Effect {
    // Base effects
    /// No observable effect
    Pure,
    /// Memory/state read
    Read,
    /// Memory/state write
    Write,
    /// Local mutable state (for self-hosting)
    ///
    /// This effect allows local mutable variables within a function scope.
    /// Unlike Write, Mut does not escape the function boundary and is
    /// safe for self-hosting the compiler.
    ///
    /// In Bahasa Melayu: `kesan Ubah`
    ///
    /// # Example
    /// ```ignore
    /// fungsi parse_expr(tokens: &[Token]) -> (Expr, &[Token]) kesan Ubah {
    ///     biar ubah idx = 0;  // Mutable local
    ///     // ... parsing logic
    /// }
    /// ```
    Mut,
    /// Memory allocation (heap)
    ///
    /// This effect tracks heap allocation operations. Used when creating
    /// new references or growing data structures.
    Alloc,
    /// File system access
    FileSystem,
    // Network effects
    /// Network I/O
    Network,
    /// Secure network (TLS)
    NetworkSecure,
    // Crypto effects
    /// Cryptographic operations
    Crypto,
    /// Random number generation
    Random,
    // System effects
    /// System calls
    System,
    /// Time/clock access
    Time,
    /// Process management
    Process,
    // RIINA product effects
    /// Panel UI operations
    Panel,
    /// Zirah API operations
    Zirah,
    /// Benteng auth operations
    Benteng,
    /// Sandi crypto operations
    Sandi,
    /// Menara device operations
    Menara,
    /// Gapura gateway operations
    Gapura,
}

/// Effect category for partial ordering.
/// Matches Coq `effect_category`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum EffectCategory {
    Pure,
    IO,
    Network,
    Crypto,
    System,
    Product,
}

impl Effect {
    /// Numeric level. Not Coq's `effect_level` numbers: `Mut` (1) and `Alloc`
    /// (3) have no Coq counterpart, so every level from `Read` up is higher here
    /// (`Read` is 2 against 1, `Gapura` 18 against 16). The relative order of
    /// the effects both sides share is the same, which is all the refinement
    /// argument on [`EffectSet`] uses.
    #[must_use]
    pub const fn level(self) -> u8 {
        match self {
            Self::Pure => 0,
            Self::Mut => 1, // Local mutation (below Read)
            Self::Read => 2,
            Self::Alloc => 3, // Heap allocation
            Self::Write => 4,
            Self::FileSystem => 5,
            Self::Network => 6,
            Self::NetworkSecure => 7,
            Self::Crypto => 8,
            Self::Random => 9,
            Self::System => 10,
            Self::Time => 11,
            Self::Process => 12,
            Self::Panel => 13,
            Self::Zirah => 14,
            Self::Benteng => 15,
            Self::Sandi => 16,
            Self::Menara => 17,
            Self::Gapura => 18,
        }
    }

    /// Category matching Coq `effect_cat`
    #[must_use]
    pub const fn category(self) -> EffectCategory {
        match self {
            Self::Pure | Self::Mut => EffectCategory::Pure, // Mut is pure from caller perspective
            Self::Read | Self::Write | Self::Alloc | Self::FileSystem => EffectCategory::IO,
            Self::Network | Self::NetworkSecure => EffectCategory::Network,
            Self::Crypto | Self::Random => EffectCategory::Crypto,
            Self::System | Self::Time | Self::Process => EffectCategory::System,
            Self::Panel
            | Self::Zirah
            | Self::Benteng
            | Self::Sandi
            | Self::Menara
            | Self::Gapura => EffectCategory::Product,
        }
    }

    /// Every effect, in ascending [`Effect::level`] order (`ALL[i].level() == i`).
    pub const ALL: [Effect; 19] = [
        Self::Pure,
        Self::Mut,
        Self::Read,
        Self::Alloc,
        Self::Write,
        Self::FileSystem,
        Self::Network,
        Self::NetworkSecure,
        Self::Crypto,
        Self::Random,
        Self::System,
        Self::Time,
        Self::Process,
        Self::Panel,
        Self::Zirah,
        Self::Benteng,
        Self::Sandi,
        Self::Menara,
        Self::Gapura,
    ];

    /// Join: max in the hierarchy (Coq `effect_join`).
    ///
    /// This is a TOTAL order and is lossy across categories (`Time ⊔
    /// FileSystem = Time`), so it must not be used to accumulate what a
    /// computation performs or what a function declares — that is
    /// [`EffectSet`], whose join is set union and whose subsumption is the
    /// category-respecting partial order [`EffectSet::covers`].
    #[must_use]
    pub const fn join(self, other: Self) -> Self {
        if self.level() < other.level() {
            other
        } else {
            self
        }
    }

    /// Check if this effect is "local" (doesn't escape function scope)
    #[must_use]
    pub const fn is_local(self) -> bool {
        matches!(self, Self::Pure | Self::Mut)
    }

    /// Map effect to a default capability kind.
    /// Matches Coq `TCapabilityOld` backward-compat mapping.
    #[must_use]
    pub const fn to_capability_kind(self) -> CapabilityKind {
        match self {
            Self::Read => CapabilityKind::FileRead,
            Self::Write | Self::Alloc | Self::FileSystem => CapabilityKind::FileWrite,
            Self::Network | Self::NetworkSecure => CapabilityKind::NetConnect,
            Self::System | Self::Time => CapabilityKind::SysTime,
            Self::Random => CapabilityKind::SysRandom,
            Self::Process => CapabilityKind::ProcSpawn,
            _ => CapabilityKind::SysRandom, // fallback
        }
    }
}

/// A SET of effects: what a computation may perform, what a function declares
/// (`kesan (Masa, SistemFail)`) and therefore what its type's latent effect is,
/// or which capabilities a scope holds.
///
/// # Why a set, not the `Effect` lattice
///
/// [`Effect::join`] is the Coq `effect_join`: the max of a TOTAL order. It is
/// lossy across categories — `Time ⊔ FileSystem = Time` — so with single-effect
/// latent types a `kesan (Masa, SistemFail)` callee looked like plain `Masa` to
/// its callers, and the "performed level ≤ declared level" check let a
/// `kesan Masa` (level 11) function write files (FileSystem, level 5) or open
/// sockets (Network, 6): declaring one capability silently authorized every
/// unrelated, lower-numbered one (audit finding M1c).
///
/// An `EffectSet` keeps every component, its `join` is set UNION (lossless),
/// and subsumption is the PARTIAL order [`EffectSet::covers`], which never lets
/// an effect of one [`EffectCategory`] stand in for one of another. Within a
/// single category the original level order still applies (`kesan SistemFail`
/// covers `Baca`; `kesan RangkaianSelamat` covers `Rangkaian`).
///
/// # Relation to the Coq model
///
/// Whatever this order accepts, the Coq total order accepts too: if each
/// performed `e` is covered by some declared `d` (same category,
/// `level e ≤ level d`), then `level e ≤ level (⊔ D)`. The prototype is thus a
/// strict REFINEMENT of Coq `effect_join`/`effect_level` — it rejects more
/// programs, never fewer — so the mechanized results still apply to every
/// program it accepts.
///
/// Representation: bit `i` is the effect whose level is `i` (levels are unique
/// and `0..=18`). `Pure` is the identity and is never stored, so the empty set
/// is "pure". Equality and hashing are structural.
#[derive(Clone, Copy, PartialEq, Eq, Hash, Default)]
pub struct EffectSet(u32);

impl EffectSet {
    /// The pure (empty) effect set.
    pub const PURE: EffectSet = EffectSet(0);

    /// The singleton set `{e}` (`Pure` gives the empty set).
    #[must_use]
    pub const fn single(e: Effect) -> Self {
        match e {
            Effect::Pure => Self::PURE,
            _ => EffectSet(1u32 << e.level()),
        }
    }

    /// The effect set a function DECLARES: the components of a compound
    /// `kesan (A, B)` annotation together with its lattice `effect` (the two
    /// agree when produced by the parser; the union keeps a hand-built
    /// declaration with an empty component list meaningful).
    #[must_use]
    pub fn from_declaration(effect: Effect, components: &[Effect]) -> Self {
        components.iter().copied().fold(Self::single(effect), Self::join)
    }

    /// Set union — the lossless join. Accepts an `Effect` or an `EffectSet`.
    #[must_use]
    pub fn join(self, other: impl Into<EffectSet>) -> Self {
        EffectSet(self.0 | other.into().0)
    }

    /// No effect at all.
    #[must_use]
    pub const fn is_pure(self) -> bool {
        self.0 == 0
    }

    /// Exact membership (`Pure` is a member of every set).
    #[must_use]
    pub const fn contains(self, e: Effect) -> bool {
        match e {
            Effect::Pure => true,
            _ => self.0 & (1u32 << e.level()) != 0,
        }
    }

    /// The members, in ascending level order (`Pure` is never listed).
    pub fn iter(self) -> impl Iterator<Item = Effect> {
        Effect::ALL
            .into_iter()
            .filter(move |e| *e != Effect::Pure && self.contains(*e))
    }

    /// Whether this (declared / held) set COVERS the single effect `e`. This is
    /// the partial order that replaces "`e.level() <= declared.level()`":
    ///
    /// * `Pure` is covered by everything (it is the identity);
    /// * `Mut` — the write to a `biar ubah` slot the function did not bind,
    ///   which its caller can observe (H2) — is covered by any NON-pure set.
    ///   It is not a capability (no I/O, no authority outside the program), so
    ///   covering it cannot reach another category; but it is observable, so
    ///   `kesan Bersih` must not cover it. That is exactly where the old total
    ///   order placed it (level 1, below every other effect);
    /// * any other `e` is covered iff some member `d` is in the SAME
    ///   [`EffectCategory`] with `e.level() <= d.level()`.
    ///
    /// `Alloc` is deliberately NOT local: it is an IO-category effect (see
    /// [`Effect::category`] and the `riina-pkg` mapping) and a `kesan Peruntuk`
    /// declaration covers `Read` (same category, lower level), so treating it
    /// as local would let a `kesan Bersih` caller reach `Read` through an
    /// Alloc-declared callee. The checker never infers `Alloc` on its own
    /// (`ruj` is charged `Write`, as in Coq T_Ref): it only arises from an
    /// explicit declaration or `laku`, where honouring it is the safe side.
    #[must_use]
    pub fn covers(self, e: Effect) -> bool {
        match e {
            Effect::Pure => true,
            Effect::Mut => !self.is_pure(),
            _ => self
                .iter()
                .any(|d| d.category() == e.category() && e.level() <= d.level()),
        }
    }

    /// Whether every member of `other` is covered (see [`EffectSet::covers`]).
    #[must_use]
    pub fn covers_all(self, other: EffectSet) -> bool {
        self.first_uncovered(other).is_none()
    }

    /// The lowest-level member of `other` this set does NOT cover, if any —
    /// the effect an effect violation reports.
    #[must_use]
    pub fn first_uncovered(self, other: EffectSet) -> Option<Effect> {
        other.iter().find(|e| !self.covers(*e))
    }

    /// The Coq-style TOTAL-order join of the members (the max level). LOSSY
    /// across categories: only for display, codegen annotations and other
    /// consumers that need a single label — never for an effect or capability
    /// check.
    #[must_use]
    pub fn total_join(self) -> Effect {
        self.iter().fold(Effect::Pure, Effect::join)
    }
}

impl From<Effect> for EffectSet {
    fn from(e: Effect) -> Self {
        Self::single(e)
    }
}

impl FromIterator<Effect> for EffectSet {
    fn from_iter<I: IntoIterator<Item = Effect>>(iter: I) -> Self {
        iter.into_iter().fold(Self::PURE, Self::join)
    }
}

impl<'a> FromIterator<&'a Effect> for EffectSet {
    fn from_iter<I: IntoIterator<Item = &'a Effect>>(iter: I) -> Self {
        iter.into_iter().copied().collect()
    }
}

/// A set equals a single effect when it is exactly that singleton (the empty
/// set is `Pure`).
impl PartialEq<Effect> for EffectSet {
    fn eq(&self, other: &Effect) -> bool {
        *self == Self::single(*other)
    }
}

impl PartialEq<EffectSet> for Effect {
    fn eq(&self, other: &EffectSet) -> bool {
        other == self
    }
}

/// Prints like `Effect` for the empty set (`Pure`) and for a singleton
/// (`Write`), so single-effect diagnostics and type renderings are unchanged;
/// a compound set prints as `{Time, FileSystem}`.
impl std::fmt::Debug for EffectSet {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut members = self.iter();
        match (members.next(), members.next()) {
            (None, _) => write!(f, "{:?}", Effect::Pure),
            (Some(e), None) => write!(f, "{e:?}"),
            _ => f.debug_set().entries(self.iter()).finish(),
        }
    }
}

/// Taint sources for untrusted data.
/// Matches Coq `taint_source` in `foundations/Syntax.v`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum TaintSource {
    NetworkExternal,
    NetworkInternal,
    UserInput,
    FileSystem,
    Database,
    Environment,
    GapuraRequest,
    ZirahEvent,
    ZirahEndpoint,
    BentengBiometric,
    SandiSignature,
    MenaraDevice,
}

/// Sanitizer markers for tainted data.
/// Coq `sanitizer` in `foundations/Syntax.v` has every variant except
/// `UrlAllowlist`; `docs/spec/CORE_MAPPING.md` maps each one.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Sanitizer {
    // Web
    HtmlEscape,
    UrlEncode,
    JsEscape,
    CssEscape,
    /// JSON string-CONTENT escaping: makes text safe to embed *inside* a JSON
    /// string literal. Mirrors Coq `SanJsonEscape`.
    ///
    /// Deliberately distinct from [`Sanitizer::JsonValidation`], which asserts
    /// that a whole document IS well-formed JSON. Conflating the two is what
    /// made `json_urai_selamat` unreachable for objects: `sanitasi_json` minted
    /// `JsonValidation` while escaping `"` and `\`, so `{"a":1}` arrived at the
    /// safe parser as `{\"a\":1}` and parsed to Unit. An escape is not a
    /// validation — it is closer to its opposite, since escaping a valid
    /// document is exactly what stops it being one.
    JsonEscape,
    // SQL
    SqlEscape,
    SqlParam,
    // Injection prevention
    XssFilter,
    PathTraversal,
    CommandEscape,
    LdapEscape,
    XmlEscape,
    UrlAllowlist,
    // Validation
    JsonValidation,
    XmlValidation,
    EmailValidation,
    PhoneValidation,
    // Bound
    LengthBound(u64),
    RangeBound(u64, u64),
    RegexMatch(std::string::String),
    Whitelist(Vec<std::string::String>),
    // Crypto
    HashVerify,
    SignatureVerify,
    MacVerify,
    // RIINA product
    GapuraAuth,
    ZirahSession,
    BentengBiometric,
    SandiDecrypt,
    MenaraAttestation,
}

/// Capability kinds for access control.
/// Matches Coq `capability_kind` in `foundations/Syntax.v`.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Copy)]
pub enum CapabilityKind {
    FileRead,
    FileWrite,
    FileExecute,
    FileDelete,
    NetConnect,
    NetListen,
    NetBind,
    ProcSpawn,
    ProcSignal,
    SysTime,
    SysRandom,
    SysEnv,
    RootProduct,
    ProductAccess,
}

/// Capability with optional constraints.
/// Matches Coq `capability` in `foundations/Syntax.v`.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Capability {
    Basic(CapabilityKind),
    Revocable(Box<Capability>),
    TimeBound(Box<Capability>, u64),
    Delegated(Box<Capability>, Ident),
}

// ============================================================================
// Store Typing (Σ)
// ============================================================================

/// Memory location identifier.
///
/// Matches Coq `loc := nat` in `foundations/Typing.v`.
/// Locations are created during reference allocation and are unique identifiers
/// for memory cells in the store.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Location(pub usize);

impl Location {
    /// Create a new location with the given index.
    #[must_use]
    pub const fn new(index: usize) -> Self {
        Self(index)
    }

    /// Get the raw index of this location.
    #[must_use]
    pub const fn index(self) -> usize {
        self.0
    }
}

impl std::fmt::Display for Location {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "loc_{}", self.0)
    }
}

/// Store typing context (Σ in the Coq type judgment).
///
/// Matches Coq `store_ty := list (loc * ty * security_level)` in `foundations/Typing.v`.
///
/// The store typing maps memory locations to their types and security levels.
/// This is used during typechecking to ensure that:
/// 1. Dereferencing a location returns the correct type
/// 2. Assignments respect type compatibility
/// 3. Security levels are preserved across memory operations
///
/// # Example
/// ```ignore
/// let mut sigma = StoreTy::new();
/// let loc = sigma.extend(Ty::Int, SecurityLevel::Public);
/// assert_eq!(sigma.lookup(&loc), Some(&(Ty::Int, SecurityLevel::Public)));
/// ```
///
/// The bindings are PERSISTENT ([`persistent::PMap`]): the typechecker clones
/// its context — Σ included — for every nested scope, so a copied map made a
/// chain of n `ruj` allocations cost O(n²) memory (5,000: 1.5 GB).
#[derive(Debug, Clone, Default)]
pub struct StoreTy {
    /// Bindings from locations to (type, security_level) pairs.
    bindings: persistent::PMap<Location, (Ty, SecurityLevel)>,
    /// Counter for generating fresh locations.
    next_loc: usize,
}

impl StoreTy {
    /// Create an empty store typing context.
    #[must_use]
    pub fn new() -> Self {
        Self::default()
    }

    /// Look up a location in the store typing.
    ///
    /// Matches Coq `store_ty_lookup l Σ : option (ty * security_level)`.
    #[must_use]
    pub fn lookup(&self, loc: &Location) -> Option<&(Ty, SecurityLevel)> {
        self.bindings.get(loc)
    }

    /// Allocate a new location with the given type and security level.
    ///
    /// Returns the freshly allocated location. This corresponds to the
    /// typing rule T_Ref which creates new entries in Σ.
    pub fn extend(&mut self, ty: Ty, sl: SecurityLevel) -> Location {
        let loc = Location::new(self.next_loc);
        self.next_loc += 1;
        self.bindings.insert(loc, (ty, sl));
        loc
    }

    /// Update the type and security level at an existing location.
    ///
    /// This is used for strong updates where the type of a location changes.
    /// Returns `true` if the location existed and was updated.
    pub fn update(&mut self, loc: Location, ty: Ty, sl: SecurityLevel) -> bool {
        if self.bindings.contains_key(&loc) {
            self.bindings.insert(loc, (ty, sl));
            true
        } else {
            false
        }
    }

    /// Check if a location exists in the store typing.
    #[must_use]
    pub fn contains(&self, loc: &Location) -> bool {
        self.bindings.contains_key(loc)
    }

    /// Get the number of locations in the store typing. Locations are only
    /// ever added (`extend`, each a fresh one), so this is the allocation
    /// count.
    #[must_use]
    pub fn len(&self) -> usize {
        self.next_loc
    }

    /// Check if the store typing is empty.
    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.next_loc == 0
    }

    /// Iterate over all (location, type, security_level) triples.
    pub fn iter(&self) -> impl Iterator<Item = (&Location, &Ty, &SecurityLevel)> {
        self.bindings.iter().map(|(l, (t, s))| (l, t, s))
    }
}

impl PartialEq for StoreTy {
    fn eq(&self, other: &Self) -> bool {
        self.len() == other.len()
            && self
                .iter()
                .all(|(l, t, s)| other.lookup(l).is_some_and(|(t2, s2)| t2 == t && s2 == s))
    }
}

impl Eq for StoreTy {}

/// Session types for binary communication protocols.
/// Matches Coq `session_type` in `foundations/Syntax.v`.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum SessionType {
    End,
    Send(Box<Ty>, Box<SessionType>),
    Recv(Box<Ty>, Box<SessionType>),
    Select(Box<SessionType>, Box<SessionType>),
    Branch(Box<SessionType>, Box<SessionType>),
    Rec(Ident, Box<SessionType>),
    Var(Ident),
}

/// Types
///
/// Type constructors for RIINA. Coq `ty` in `foundations/Syntax.v` covers a
/// subset; `docs/spec/CORE_MAPPING.md` maps each variant and
/// `riinac/tests/core_mapping.rs` fails when one is added without a row.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Ty {
    // Primitive types
    Unit,
    Bool,
    /// The default integer type (`Nombor`) — an unbounded machine integer.
    Int,
    /// A sized integer type (numeric-tower slice): `bits` ∈ {8,16,32,64},
    /// `signed` distinguishes `iN` from `uN` (e.g. `u8` = `{bits:8, signed:false}`).
    /// Representationally compatible with `Int` for codegen; width-aware
    /// arithmetic semantics are a later numeric-tower phase.
    IntN { bits: u8, signed: bool },
    /// Arbitrary-precision signed integer (`besar`) — the numeric-tower BigInt
    /// type. A distinct type that does NOT silently interoperate with `Int`
    /// (mixing would hide a precision boundary); convert explicitly via `besar`.
    BigInt,
    /// Arbitrary-precision decimal (`perpuluhan`) — exact base-10 arithmetic for
    /// finance. A distinct type; does not silently mix with `Int`/`BigInt`.
    Decimal,
    /// Fixed-scale decimal (`wang` money / `titik_tetap`) — a `mantissa` with a
    /// *fixed* scale: arithmetic rounds half-to-even back to that scale and
    /// display preserves trailing zeros (`3.30`, `100.00`). A distinct type; does
    /// not silently mix with `Int`/`BigInt`/`Decimal`.
    Fixed,
    /// Binary fixed-point — Q-format (`qmn`): `raw / 2^frac_bits` over a bounded
    /// machine word (arithmetic wraps on overflow). A distinct type; does not
    /// silently mix with the other numeric types.
    FixedBin,
    String,
    Bytes,
    // Function types
    /// T1 -[ε]-> T2. The latent effect ε is an [`EffectSet`], not a single
    /// `Effect`: a compound declaration `kesan (Masa, SistemFail)` must reach
    /// the callers of a function value with every component intact (M1c).
    Fn(Box<Ty>, Box<Ty>, EffectSet),
    // Compound types
    /// T1 × T2
    Prod(Box<Ty>, Box<Ty>),
    /// T1 + T2
    Sum(Box<Ty>, Box<Ty>),
    /// List[T]
    List(Box<Ty>),
    /// Option[T]
    Option(Box<Ty>),
    // Reference types
    /// Ref[T]@l
    Ref(Box<Ty>, SecurityLevel),
    // Security types
    /// Secret[T] - classified data
    Secret(Box<Ty>),
    /// Labeled[T, l] - security label
    Labeled(Box<Ty>, SecurityLevel),
    /// Tainted[T, src] - tainted data
    Tainted(Box<Ty>, TaintSource),
    /// Sanitized[T, san] - sanitized data
    Sanitized(Box<Ty>, Sanitizer),
    /// Proof[T] - declassification proof
    Proof(Box<Ty>),
    // Capability types
    /// Cap[kind] - simple capability
    Capability(CapabilityKind),
    /// Full capability with constraints
    CapabilityFull(Capability),
    // Session types
    /// Chan[S] - channel with session
    Chan(SessionType),
    /// SecureChan[S, l] - secure channel
    SecureChan(SessionType, SecurityLevel),
    // Constant-time types
    /// ConstantTime[T] - for crypto
    ConstantTime(Box<Ty>),
    /// Zeroizing[T] - cleared on drop
    Zeroizing(Box<Ty>),
    /// Any type — matches any type during typechecking (for polymorphic builtins).
    /// Rust-only extension, not in Coq.
    Any,
    // FFI types (C interop)
    /// Raw pointer (*T) for FFI boundary
    RawPtr(Box<Ty>),
    /// C char type
    CChar,
    /// C int type
    CInt,
    /// C void type
    CVoid,

    // ── JALINAN Phase 6 types ──────────────────────────────────────────
    /// Actor[State, Msg] — typed actor reference with state and message types
    Actor(Box<Ty>, Box<Ty>),
    /// Choreography[roles, protocol] — global multiparty session protocol
    Choreography(Vec<Ident>, SessionType),
    /// ContentAddressed[T] — content-addressed (Merkle) value
    ContentAddressed(Box<Ty>),
    /// CRDT[T, Op] — conflict-free replicated data type
    CRDT(Box<Ty>, Box<Ty>),
    /// Supervisor[T] — fault-tolerance supervisor for actor type T
    Supervisor(Box<Ty>),

    // ── Blockchain + Syariah Phase J6 types ─────────────────────────
    /// SmartContract[T] — capability-gated smart-contract state
    SmartContract(Box<Ty>),
    /// Token[T] — conserved transferable value
    Token(Box<Ty>),
    /// SyariahCompliant[T] — effect-constrained value
    SyariahCompliant(Box<Ty>),

    // ── CAHAYA Phase J5 types ──────────────────────────────────────
    /// Color — RGBA color with compile-time contrast checking
    Color,
    /// Element — UI element type
    Element,
    /// Layout — container for UI elements
    Layout,
    /// Style — CSS-like style properties
    UIStyle,
    /// AccessibleText — text with proven WCAG contrast
    AccessibleText,
}

/// Binary operators
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BinOp {
    // Arithmetic
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    // Comparison
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    // Logical
    And,
    Or,
}

/// A source span (byte offsets) for LSP support.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

impl Span {
    #[must_use]
    pub const fn new(start: usize, end: usize) -> Self {
        Self { start, end }
    }

    /// Merge two spans into one covering both.
    #[must_use]
    pub const fn merge(self, other: Self) -> Self {
        Self {
            start: if self.start < other.start {
                self.start
            } else {
                other.start
            },
            end: if self.end > other.end {
                self.end
            } else {
                other.end
            },
        }
    }
}

/// A top-level declaration in a .rii file.
/// These are parsed but desugared to expressions for typechecking/codegen.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TopLevelDecl {
    /// fungsi name(params) -> return_ty kesan eff { body }
    Function {
        name: Ident,
        params: Vec<(Ident, Ty)>,
        return_ty: Ty,
        /// The function's effect as a single lattice value (the total-order
        /// join of the declared components). LOSSY for a compound declaration
        /// — display and codegen only; every check uses
        /// [`EffectSet::from_declaration`]`(effect, &effect_set)`.
        effect: Effect,
        /// The *components* of a compound declared effect (`kesan (A, B, C)` ⇒
        /// `[A, B, C]`). The lattice `effect` field is lossy (it collapses a
        /// compound to the max-level component), so this preserves the full
        /// set: it is the function type's latent [`EffectSet`], what its body
        /// is checked against, and what is granted in its body. For a single
        /// declared effect this is a one-element vector.
        effect_set: Vec<Effect>,
        body: Box<Expr>,
    },
    /// `biar name = expr;` at top level. `is_mut` records a `biar ubah`, which
    /// becomes an [`Expr::LetMut`] slot rather than an immutable [`Expr::Let`] —
    /// without it a top-level `selagi` counting down a top-level counter never
    /// terminates, because the write is discarded.
    Binding {
        name: Ident,
        value: Box<Expr>,
        is_mut: bool,
    },
    /// Expression at top level (the program's main expression)
    Expr(Box<Expr>),
    /// luaran "C" { ... } — extern block for FFI declarations
    ExternBlock { abi: String, decls: Vec<ExternDecl> },
    /// ujian "name" { body } — inline test block
    Test { name: String, body: Box<Expr> },
}

/// A single declaration inside an extern block.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ExternDecl {
    pub name: Ident,
    pub params: Vec<(Ident, Ty)>,
    pub ret_ty: Ty,
    pub effect: Effect,
}

/// A spanned top-level declaration.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SpannedDecl {
    pub decl: TopLevelDecl,
    pub span: Span,
    /// Span of just the name (for go-to-definition).
    pub name_span: Option<Span>,
}

/// One `guna <name>;` import of a sibling `.rii` file (REQ-71).
///
/// Only a SINGLE-segment path is a file import. A multi-segment path such as
/// `guna std::teks;` names the builtin namespace, carries no file, and is not
/// recorded here — that keeps every pre-module-system example working.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Import {
    /// The module name, which is also its file stem (`kira` ⇒ `kira.rii`).
    pub module: Ident,
    /// Span of the module name, for diagnostics.
    pub span: Span,
}

/// A complete .rii file
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Program {
    pub decls: Vec<TopLevelDecl>,
    /// Parallel span info for each decl (same length as `decls`).
    pub spans: Vec<SpannedDecl>,
    /// Sibling modules imported with `guna <name>;`, in source order (REQ-71).
    /// Empty for a single-file program, which is why `new`/`with_spans` still
    /// build a valid `Program` without mentioning it.
    pub imports: Vec<Import>,
    /// Top-level names declared `awam` (public). Everything else is
    /// module-private and may not be named from another module (REQ-71).
    pub public_names: Vec<Ident>,
}

/// Parameter name given to a zero-parameter function's synthesised `()` param.
///
/// Leading `_` keeps it out of unused-name diagnostics, and nothing in
/// `07_EXAMPLES` or the stdlib binds it, so the synthesised binder cannot shadow
/// a name the body needs.
pub const UNIT_PARAM: &str = "_unit";

/// The program entry point, invoked automatically when a program has no
/// trailing top-level expression.
pub const ENTRY_POINT: &str = "utama";

/// The declared type of a function with these parameters, return type and
/// effect — `(A, B) -> R ! E` becomes `A -> B -> R ! E`.
///
/// A ZERO-parameter function is `Unit -> R ! E`, matching the synthesised `()`
/// parameter `build_lambda` gives it. This is the single source of truth: the
/// typechecker seeds its top-level environment from here and desugaring builds
/// the matching lambda from here, so the two cannot disagree about a function's
/// arity. They did disagree — the typechecker kept computing the old bare
/// return type for zero-parameter functions after desugaring had moved on, and
/// every zero-arg call then failed with "Expected function type, found Int".
///
/// `effect` is the function's whole DECLARED effect set (pass
/// [`EffectSet::from_declaration`] for a `TopLevelDecl::Function`); a single
/// `Effect` converts. Passing only the lossy lattice join would hide the other
/// components of a compound declaration from every caller (M1c).
#[must_use]
pub fn declared_fn_ty(params: &[(Ident, Ty)], return_ty: &Ty, effect: impl Into<EffectSet>) -> Ty {
    let effect = effect.into();
    if params.is_empty() {
        return Ty::Fn(Box::new(Ty::Unit), Box::new(return_ty.clone()), effect);
    }
    params
        .iter()
        .rev()
        .fold(return_ty.clone(), |ret, (_, param_ty)| {
            Ty::Fn(Box::new(param_ty.clone()), Box::new(ret), effect)
        })
}

/// Desugar a single function decl into a LetRec binding.
#[allow(clippy::boxed_local)]
/// Build the (lambda, function-type) pair for a top-level function decl.
///
/// A zero-parameter function gets a SYNTHESISED `()` parameter, so it is a real
/// function like any other: `fungsi f() -> T kesan E` becomes
/// `Lam(_unit, Unit, body) : Unit -> T ! E`.
///
/// It used to yield its body directly, as a bare binding typed at the return
/// type — "a global thunk". That was not a function in any sense that survived
/// contact with the semantics (master plan REQ-68), and all three of these were
/// measured, with the interpreter and C backend agreeing on the wrong answer:
///   * the body ran ONCE, when the binding was evaluated, no matter how many
///     times it was called — two calls printed one line;
///   * it ran even when the function was NEVER called;
///   * it ran BEFORE `utama`, so its output preceded the program's own first
///     line, and its effects escaped their function entirely.
///
/// `pulang` was broken there too: with no `Lam` there was no IR function to
/// return from, so an early return would have returned from the CALLER (REQ-80).
#[must_use]
pub fn desugar_function(
    params: Vec<(Ident, Ty)>,
    return_ty: Ty,
    effect: impl Into<EffectSet>,
    body: Box<Expr>,
) -> (Expr, Ty) {
    let fn_ty = declared_fn_ty(&params, &return_ty, effect);
    if params.is_empty() {
        return (Expr::Lam(UNIT_PARAM.to_string(), Ty::Unit, body), fn_ty);
    }
    let lam = params.iter().rev().fold(*body, |acc, (p, ty)| {
        Expr::Lam(p.clone(), ty.clone(), Box::new(acc))
    });
    (lam, fn_ty)
}

/// Desugar an extern block into Let bindings for each extern decl.
fn desugar_extern_block(decls: Vec<ExternDecl>, continuation: Expr) -> Expr {
    let mut result = continuation;
    for decl in decls.into_iter().rev() {
        let param_names: Vec<Ident> = decl.params.iter().map(|(n, _)| n.clone()).collect();
        let args: Vec<Expr> = param_names.iter().map(|n| Expr::Var(n.clone())).collect();
        let ffi_call = Expr::FFICall {
            name: decl.name.clone(),
            args,
            ret_ty: decl.ret_ty.clone(),
        };
        let lam = decl.params.iter().rev().fold(ffi_call, |acc, (p, ty)| {
            Expr::Lam(p.clone(), ty.clone(), Box::new(acc))
        });
        result = Expr::Let(decl.name, None, Box::new(lam), Box::new(result));
    }
    result
}

impl Program {
    /// Create a Program without span info (backwards compat).
    #[must_use]
    pub fn new(decls: Vec<TopLevelDecl>) -> Self {
        Self {
            spans: Vec::new(),
            decls,
            imports: Vec::new(),
            public_names: Vec::new(),
        }
    }

    /// Create a Program with span info.
    #[must_use]
    pub fn with_spans(decls: Vec<TopLevelDecl>, spans: Vec<SpannedDecl>) -> Self {
        Self {
            decls,
            spans,
            imports: Vec::new(),
            public_names: Vec::new(),
        }
    }

    /// Create a Program carrying module metadata (REQ-71 module system).
    #[must_use]
    pub fn with_modules(
        decls: Vec<TopLevelDecl>,
        spans: Vec<SpannedDecl>,
        imports: Vec<Import>,
        public_names: Vec<Ident>,
    ) -> Self {
        Self {
            decls,
            spans,
            imports,
            public_names,
        }
    }

    /// Whether `decls` declares the entry point as a ZERO-parameter function.
    ///
    /// Only a zero-parameter `utama` is auto-invoked: one that takes arguments
    /// has nothing to pass it, so it stays a plain binding rather than becoming
    /// an application that could not type-check.
    fn declares_entry_point(decls: &[TopLevelDecl]) -> bool {
        decls.iter().any(|d| {
            matches!(
                d,
                TopLevelDecl::Function { name, params, .. }
                    if name == ENTRY_POINT && params.is_empty()
            )
        })
    }

    /// Desugar a program into a single expression.
    /// Functions become LetRec + Lam (recursive binding), bindings become Let,
    /// extern blocks introduce FFICall wrappers, and the final expression is
    /// the program's value.
    #[must_use]
    pub fn desugar(self) -> Expr {
        let mut decls = self.decls;
        if decls.is_empty() {
            return Expr::Unit;
        }

        // A trailing top-level EXPRESSION is the program body; everything else
        // (including the trailing function — usually `utama`) is a binding, so
        // all top-level functions land in the mutually-recursive group built by
        // `wrap_decls` (REQ-44 forward references).
        //
        // Otherwise the body CALLS `utama`. It used to be left as `Unit`, which
        // worked only because a zero-parameter function was a thunk: evaluating
        // its binding ran its body, so the program ran as a side effect of being
        // bound. Now that `utama` is a real `Unit -> T` function (REQ-68),
        // nothing would run unless it is applied.
        let body = if matches!(decls.last(), Some(TopLevelDecl::Expr(_))) {
            match decls.pop() {
                Some(TopLevelDecl::Expr(e)) => *e,
                _ => Expr::Unit,
            }
        } else if Self::declares_entry_point(&decls) {
            // The call is SEQUENCED, not returned: the program's value stays
            // `Unit`, exactly as when `utama`'s binding ran it. Returning it
            // instead would make every compiled program print its own exit code
            // as a trailing line (measured: `satu` became `satu\n7`), because
            // the backends print a non-Unit program value.
            Expr::Let(
                "_".to_string(),
                None,
                Box::new(Expr::App(
                    Box::new(Expr::Var(ENTRY_POINT.to_string())),
                    Box::new(Expr::Unit),
                )),
                Box::new(Expr::Unit),
            )
        } else {
            Expr::Unit
        };

        Self::wrap_decls(decls, body)
    }

    /// Desugar declarations with a specific body expression.
    ///
    /// This is useful for the test runner: desugar the non-test declarations
    /// once for each test body, without needing to push a fake TopLevelDecl::Expr.
    pub fn desugar_with_body(self, body: Expr) -> Expr {
        Self::wrap_decls(self.decls, body)
    }

    /// Wrap a body expression with a chain of Let/LetRec bindings from declarations.
    fn wrap_decls(decls: Vec<TopLevelDecl>, body: Expr) -> Expr {
        let mut result = body;
        // Consecutive top-level function decls form ONE mutually-recursive group
        // (all names in scope in every body + the continuation) so forward
        // references / mutual recursion work (REQ-44). Non-function decls flush
        // the pending group and wrap as before, preserving backward-ref scoping
        // (a function can still see an earlier top-level `biar` binding).
        // Iterating back-to-front, we accumulate functions in `pending` (reversed)
        // and flush on any non-function decl or at the end.
        let mut pending: Vec<(Ident, Ty, Expr)> = Vec::new();
        let flush = |pending: &mut Vec<(Ident, Ty, Expr)>, result: Expr| -> Expr {
            if pending.is_empty() {
                result
            } else {
                pending.reverse(); // restore source order
                Expr::LetRecGroup(std::mem::take(pending), Box::new(result))
            }
        };
        for decl in decls.into_iter().rev() {
            match decl {
                TopLevelDecl::Function {
                    name,
                    params,
                    return_ty,
                    effect,
                    effect_set,
                    body,
                } => {
                    let declared = EffectSet::from_declaration(effect, &effect_set);
                    let (lam, fn_ty) = desugar_function(params, return_ty, declared, body);
                    pending.push((name, fn_ty, lam));
                }
                TopLevelDecl::Expr(e) => {
                    result = flush(&mut pending, result);
                    let bind_name = match e.as_ref() {
                        Expr::ActorDecl { name, .. } => name.clone(),
                        _ => "_".to_string(),
                    };
                    result = Expr::Let(bind_name, None, e, Box::new(result));
                }
                TopLevelDecl::Binding {
                    name,
                    value,
                    is_mut,
                } => {
                    result = flush(&mut pending, result);
                    result = if is_mut {
                        Expr::LetMut(name, value, Box::new(result))
                    } else {
                        Expr::Let(name, None, value, Box::new(result))
                    };
                }
                TopLevelDecl::ExternBlock { decls: edecls, .. } => {
                    result = flush(&mut pending, result);
                    result = desugar_extern_block(edecls, result);
                }
                TopLevelDecl::Test { .. } => {
                    result = flush(&mut pending, result);
                }
            }
        }
        flush(&mut pending, result)
    }
}

/// Expressions
///
/// Expression forms. Coq `expr` in `foundations/Syntax.v` covers a subset;
/// `docs/spec/CORE_MAPPING.md` maps each variant, and
/// `riinac/tests/core_mapping.rs` fails when one is added without a row.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Expr {
    // Values
    Unit,
    Bool(bool),
    Int(u64), // Using u64 to represent nat/int
    /// Sized integer literal: `42u8`, `7i32`. The numeric-tower counterpart of
    /// `Int`, carrying the bit width and signedness so it types as the distinct
    /// `Ty::IntN { bits, signed }` (not the default `Ty::Int`) and so arithmetic
    /// wraps at the declared width. `value` holds the lexed magnitude already
    /// reduced modulo `2^bits` (a leading `-` is a separate unary-minus token, so
    /// `-128i8` is `Neg(IntN{value:128,..})`). Kept as an additive variant so the
    /// hundreds of existing `Int(_)` sites are untouched.
    IntN { value: u64, bits: u8, signed: bool },
    String(String),
    Var(Ident),

    // Functions
    /// λx:T. e
    Lam(Ident, Ty, Box<Expr>),
    /// e1 e2
    App(Box<Expr>, Box<Expr>),

    // Products
    /// (e1, e2)
    Pair(Box<Expr>, Box<Expr>),
    /// fst e
    Fst(Box<Expr>),
    /// snd e
    Snd(Box<Expr>),

    // Sums
    /// inl e : T
    Inl(Box<Expr>, Ty),
    /// inr e : T
    Inr(Box<Expr>, Ty),
    /// case e of inl x => e1 | inr y => e2
    Case(Box<Expr>, Ident, Box<Expr>, Ident, Box<Expr>),

    // Control
    /// if e1 then e2 else e3
    If(Box<Expr>, Box<Expr>, Box<Expr>),
    /// let x = e1 in e2 (with optional linearity qualifier)
    Let(Ident, Option<Linearity>, Box<Expr>, Box<Expr>),
    /// Early return: `pulang e`. Evaluating it unwinds to the nearest enclosing
    /// function-application boundary, yielding `e` as that call's result. Its own
    /// type is `Any` (it never returns to its evaluation context), so it unifies
    /// with any branch/sequence type.
    Return(Box<Expr>),
    /// `selagi cond { body }` — iterate `body` while `cond` evaluates to true.
    ///
    /// A real loop, not a desugaring. Until 2026-08 `selagi` was rewritten by the
    /// parser into `if cond { body; () } else { ()}`, which executed the body at
    /// most ONCE while presenting itself as a loop — silently wrong output with
    /// no diagnostic. A dedicated node keeps `pulang` unwinding to the enclosing
    /// FUNCTION (a lambda-based desugaring would have caught it one iteration
    /// out) and gives `putus`/`lanjut` a scope to name.
    ///
    /// The loop's own value is always `()`; RIINA's mutable state lives in `ruj`
    /// cells (the store), so nothing is carried between iterations in a binding
    /// and the CFG needs no loop-header phi.
    While(Box<Expr>, Box<Expr>),
    /// `putus` — exit the innermost enclosing loop. Type `Any` (it never returns
    /// to its evaluation context), so it unifies with any branch type.
    Break,
    /// `lanjut` — skip to the next iteration of the innermost enclosing loop.
    /// Type `Any`, as for `Break`.
    Continue,

    // ── Mutable locals ────────────────────────────────────────────────────
    // A `biar ubah x` binding is a genuine mutable SLOT, distinct from both an
    // immutable `biar` and a first-class `ruj` cell.
    //
    // Until 2026-08 `ubah` was decorative: `x = e;` re-parsed as a shadowing
    // `biar`, so a write inside a `kalau`/loop body was discarded at the closing
    // brace with no diagnostic. Real loops make that unfixable by convention —
    // an accumulator that resets every iteration either loops forever or answers
    // wrong — so the slot is now real.
    //
    // Slots are deliberately NOT `Ref`/`Deref`/`Assign`: those carry
    // `Effect::Read`/`Effect::Write` because a `ruj` cell is first class and can
    // escape, and their rules mirror Coq `Typing.v` T_Ref/T_Deref/T_Assign,
    // which must not be weakened. A slot cannot escape — the parser emits
    // `SlotGet`/`SlotSet` only for names it has in lexical scope and never
    // exposes the slot itself as a value — so reading and writing one is
    // observationally pure, the standard encapsulated-state result. Like `While`,
    // `Return` and `BinOp`, these are compiler-level nodes with no counterpart in
    // `foundations/Syntax.v` yet; see `docs/guide/MUTABLE_STATE.md`.
    /// `biar ubah x = e1; e2` — bind a fresh mutable slot for the extent of `e2`.
    LetMut(Ident, Box<Expr>, Box<Expr>),
    /// Read the mutable slot bound to this name.
    SlotGet(Ident),
    /// `x = e` — write the mutable slot bound to this name. Value is `()`.
    SlotSet(Ident, Box<Expr>),

    // Effects
    /// perform ε e
    Perform(Effect, Box<Expr>),
    /// handle e with x => h
    Handle(Box<Expr>, Ident, Box<Expr>),

    // References
    /// ref e @ l
    Ref(Box<Expr>, SecurityLevel),
    /// !e
    Deref(Box<Expr>),
    /// e1 := e2
    Assign(Box<Expr>, Box<Expr>),

    // Security
    /// classify e
    Classify(Box<Expr>),
    /// declassify e with proof
    Declassify(Box<Expr>, Box<Expr>),
    /// prove e
    Prove(Box<Expr>),

    // Capabilities
    /// require ε in e
    Require(Effect, Box<Expr>),
    /// grant ε to e
    Grant(Effect, Box<Expr>),

    // Locations (runtime only — corresponds to Coq `ELoc : nat -> expr`)
    /// Store location (not in source; created during evaluation)
    Loc(u64),

    // Recursive binding
    /// let rec f : T = e1 in e2
    LetRec(Ident, Ty, Box<Expr>, Box<Expr>),
    /// Mutually-recursive binding GROUP: `let rec f1:T1=e1 and ... and fn:Tn=en in cont`.
    /// All group names are in scope in every bound expression AND the continuation,
    /// so top-level functions can forward-reference / mutually recurse (REQ-44).
    /// Each entry is (name, declared type, bound lambda). Mechanized-sound: the
    /// recursion rule is proven type-safe in `foundations/RecursionSafety.v` (`fix`);
    /// `let rec f = lam` = `let f = fix(λf.lam)`, generalized to a group here.
    LetRecGroup(Vec<(Ident, Ty, Expr)>, Box<Expr>),

    // Binary operations
    /// e1 op e2
    BinOp(BinOp, Box<Expr>, Box<Expr>),

    // Collections
    /// List literal: [e1, e2, ...]. Empty `[]` is the empty list.
    ListLit(Vec<Expr>),
    /// Record literal: `Name { field1: e1, field2: e2, ... }`. The type name is
    /// retained for diagnostics only; records are structural (string-keyed) at
    /// runtime. Fields are stored in source order.
    RecordLit(Ident, Vec<(Ident, Expr)>),
    /// Field access: `e.field`.
    FieldAccess(Box<Expr>, Ident),

    // FFI
    /// Foreign function call
    FFICall {
        name: String,
        args: Vec<Expr>,
        ret_ty: Ty,
    },

    // ── JALINAN Phase 6 expressions ────────────────────────────────────
    /// Actor declaration: pelaku Name { keadaan: StateType, kendalikan msg { ... } }
    ActorDecl {
        name: Ident,
        state_ty: Ty,
        message_ty: Ty,
        init_state: Box<Expr>,
        handler: Box<Expr>,
    },
    /// Choreography block: koreografi ProtocolName { peranan A, B; ... }
    ChoreographyBlock {
        name: Ident,
        roles: Vec<Ident>,
        protocol: SessionType,
    },
    /// Spawn actor: lahir ActorType(init_state)
    Spawn(Box<Expr>, Box<Expr>),
    /// Send message to actor: hantar(actor, message)
    ActorSend(Box<Expr>, Box<Expr>),
    /// Receive message from actor: terima(actor)
    ActorRecv(Box<Expr>),
    /// CRDT merge: gabung(crdt1, crdt2)
    CRDTMerge(Box<Expr>, Box<Expr>),
    /// Content hash: cincang(value)
    ContentHash(Box<Expr>),
    /// Content hash verification: sahkan(expected_hash, value)
    ContentVerify(Box<Expr>, Box<Expr>),

    // ── Blockchain + Syariah Phase J6 expressions ───────────────────
    /// Smart-contract deployment: kontrak_pintar { expr }
    ContractDeploy(Box<Expr>),
    /// Token transfer: token::pindah(from, to, amount)
    TokenTransfer {
        from: Box<Expr>,
        to: Box<Expr>,
        amount: Box<Expr>,
    },
    /// Zakat calculation: zakat(expr)
    ZakatCalculate(Box<Expr>),

    // ── CAHAYA Phase J5 expressions ────────────────────────────────
    /// UI display block: paparan { ... }
    UIDisplay(Vec<Expr>),
    /// Row layout: baris { child1; child2; ... }
    UIRow(Vec<Expr>),
    /// Column layout: lajur { child1; child2; ... }
    UIColumn(Vec<Expr>),
    /// Text element: tulisan("Hello", warna(255, 255, 255))
    UIText(Box<Expr>, Box<Expr>),
    /// Button: butang("Click", handler)
    UIButton(Box<Expr>, Box<Expr>),
    /// Color literal: warna(r, g, b)
    UIColor(u8, u8, u8),
    /// Style: gaya { pelapik: 16, saiz_fon: 14 }
    UIStyleDecl {
        padding: Option<u32>,
        font_size: Option<u32>,
    },
    /// Contrast check: kontras(fg_color, bg_color) — returns Bool
    UIContrastCheck(Box<Expr>, Box<Expr>),
}

/// Crypto-agility (REQ-48): the algorithm-deprecation policy.
///
/// This is the Rust counterpart of the Coq `accepts` judgment in
/// `02_FORMAL/coq/crypto/AlgorithmPolicy.v`. That development proves the check
/// is SOUND (an accepted program uses no deprecated algorithm) and COMPLETE (it
/// accepts every program that uses only current algorithms, so a rejection is
/// always a real deprecated use — no false positives), and that deprecating one
/// algorithm only affects programs that use it. The check below is the
/// operational realisation of `accepts pol (CUse a)` = `pol a = Current`.
///
/// The policy is data, not code: `DEPRECATED` is the classified list. Advancing
/// a deprecation date is editing this table, exactly as the mechanized
/// `tighten` lemma models — "P-256 after 2030" is a policy change, and by
/// `deprecation_is_local` it cannot break a program that does not use P-256.
///
/// It lives in `riina-types` — the one crate both the typechecker and the
/// interpreter depend on — because the policy is consulted TWICE: statically,
/// at a selection site whose algorithm name is a literal
/// (`riina_typechecker::deprecated_algorithm_at_selection`), and at runtime,
/// at every selection whatever the name's provenance
/// (`riina_codegen::builtins::kripto`). One table means the two gates cannot
/// disagree; a second copy would be a second policy.
pub mod crypto_policy {
    /// Algorithm names that are deprecated by the active policy. Matched
    /// case-insensitively against the algorithm string a program selects.
    ///
    /// Grounds (NIST IR 8547 / general hygiene): the classical primitives are
    /// slated for removal by 2035, and the broken ones are already unsafe. This
    /// list is the migration lever — a language can make selecting one a
    /// compile-time error, which a library cannot.
    pub const DEPRECATED: &[&str] = &[
        // Broken — deprecated unconditionally.
        "md5", "sha1", "sha-1", "des", "3des", "triple-des", "rc4", "md4",
        // Classical asymmetric — NIST IR 8547 removal target (2035), migrate to PQC/hybrid.
        "rsa1024", "rsa-1024", "dsa1024",
    ];

    /// The mechanized `pol a = Current` check: is this algorithm name currently
    /// allowed? A name not in `DEPRECATED` is `Current`.
    #[must_use]
    pub fn is_current(algorithm: &str) -> bool {
        let a = algorithm.to_ascii_lowercase();
        !DEPRECATED.iter().any(|d| a == *d)
    }

    /// A one-line rationale for a rejected algorithm, for the diagnostic.
    #[must_use]
    pub fn deprecation_reason(algorithm: &str) -> &'static str {
        let a = algorithm.to_ascii_lowercase();
        match a.as_str() {
            "md5" | "sha1" | "sha-1" | "md4" => "cryptographically broken (collisions)",
            "des" | "3des" | "triple-des" => "inadequate key size / sweet32",
            "rc4" => "biased keystream, prohibited by RFC 7465",
            _ => "scheduled for removal (NIST IR 8547); migrate to a PQC or hybrid algorithm",
        }
    }
}

#[cfg(test)]
mod effect_set_tests {
    use super::{Effect, EffectSet};

    fn set(effs: &[Effect]) -> EffectSet {
        effs.iter().collect()
    }

    #[test]
    fn all_is_indexed_by_level() {
        for (i, e) in Effect::ALL.iter().enumerate() {
            assert_eq!(usize::from(e.level()), i, "{e:?}");
        }
    }

    #[test]
    fn join_is_lossless_union() {
        let s = EffectSet::from(Effect::Time).join(Effect::FileSystem);
        assert!(s.contains(Effect::Time) && s.contains(Effect::FileSystem));
        assert_eq!(s.iter().collect::<Vec<_>>(), [Effect::FileSystem, Effect::Time]);
        // The lattice join of the same two effects forgets FileSystem.
        assert_eq!(Effect::Time.join(Effect::FileSystem), Effect::Time);
        assert_eq!(s.total_join(), Effect::Time);
        // Pure is the identity and is never stored.
        assert!(EffectSet::from(Effect::Pure).is_pure());
        assert_eq!(EffectSet::PURE.join(Effect::Write), Effect::Write);
    }

    #[test]
    fn covers_never_crosses_a_category() {
        let time = EffectSet::from(Effect::Time);
        for e in [Effect::FileSystem, Effect::Write, Effect::Read, Effect::Network, Effect::Crypto] {
            assert!(!time.covers(e), "Time must not cover {e:?}");
        }
        // Within a category the level order still applies...
        assert!(time.covers(Effect::System));
        assert!(EffectSet::from(Effect::FileSystem).covers(Effect::Read));
        assert!(EffectSet::from(Effect::NetworkSecure).covers(Effect::Network));
        // ...upwards only.
        assert!(!EffectSet::from(Effect::Network).covers(Effect::NetworkSecure));
        // A compound declaration covers each of its components' categories.
        let both = set(&[Effect::Time, Effect::FileSystem]);
        assert!(both.covers_all(set(&[Effect::System, Effect::Write, Effect::Time])));
        assert_eq!(both.first_uncovered(set(&[Effect::Read, Effect::Network])), Some(Effect::Network));
    }

    #[test]
    fn pure_mut_and_alloc_coverage() {
        assert!(EffectSet::PURE.covers(Effect::Pure));
        // Mut (an observable write to an outer slot) is covered by any
        // effectful declaration, never by Bersih.
        assert!(!EffectSet::PURE.covers(Effect::Mut));
        assert!(EffectSet::from(Effect::Mut).covers(Effect::Mut));
        assert!(EffectSet::from(Effect::Network).covers(Effect::Mut));
        // Alloc is an IO effect, not local: Bersih does not cover it, and
        // a Peruntuk declaration covers Read but not Write.
        assert!(!EffectSet::PURE.covers(Effect::Alloc));
        assert!(EffectSet::from(Effect::Alloc).covers(Effect::Read));
        assert!(!EffectSet::from(Effect::Alloc).covers(Effect::Write));
    }

    #[test]
    fn refines_the_total_order() {
        // Everything the partial order accepts, the Coq total order accepts.
        for d in Effect::ALL {
            for e in Effect::ALL {
                if EffectSet::from(d).covers(e) {
                    assert!(e.level() <= d.level(), "{d:?} covers {e:?}");
                }
            }
        }
    }

    #[test]
    fn debug_matches_effect_for_singletons() {
        assert_eq!(format!("{:?}", EffectSet::PURE), "Pure");
        assert_eq!(format!("{:?}", EffectSet::from(Effect::Write)), "Write");
        assert_eq!(
            format!("{:?}", set(&[Effect::Time, Effect::FileSystem])),
            "{FileSystem, Time}"
        );
        assert_eq!(EffectSet::from_declaration(Effect::Time, &[Effect::FileSystem, Effect::Time]),
                   set(&[Effect::Time, Effect::FileSystem]));
    }
}
