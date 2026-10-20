# RIINA licensing — draft texts for counsel review

**Status: DRAFT. NOT IN FORCE. NOT LEGAL ADVICE.** The binding licence is the
repository's `LICENSE` file, unchanged. Nothing here changes it. These are
drafting proposals written by an engineering session under owner ruling D5
(2026-10-19: "licence fixes within the proprietary model, subject to counsel
review"). Qualified counsel must review every clause, in particular
enforceability under the laws of Malaysia, before the owner adopts any of it.
A public licence grant cannot be withdrawn once given, so these texts must not
be published as terms before that review.

The analysis behind each draft is the D5 decision package in
`RIINA_MASTER_PLAN.md` Part 11. That package also holds the clause-by-clause
conflict table, the options memo and the open questions for the owner.

Bracketed text such as `[N]` or `[contact]` is a value the owner chooses.

---

## Draft 1 — Amended `LICENSE`

> RIINA™ LICENSE, version 2 (draft)
>
> Copyright (c) 2026 The RIINA Authors. All rights reserved except as granted
> below.
>
> **1. Definitions.**
> "Compiler" means the RIINA compiler, its associated tools, libraries,
> formal proofs, specifications and documentation, in source or binary form,
> as published by The RIINA Authors.
> "Runtime Library" means code that the Compiler copies, embeds or generates
> into Output, including the runtime prelude written into emitted C and
> WebAssembly.
> "Your Source" means programs you write in the RIINA language.
> "Output" means any file the Compiler produces from Your Source, including
> emitted C, WebAssembly, object code and executables, together with any
> Runtime Library it contains.
>
> **2. Source access, building, testing and audit.** You may view, download
> and clone the Compiler's source; build it; run its test suites and proof
> builds; and inspect, analyse, review and test it, including for security
> research and for paid audit or certification work. You may publish the
> results of that work, including reports that quote short excerpts of the
> source where the excerpt is needed to describe a finding.
>
> **3. Use.** You may use the Compiler, for commercial and non-commercial
> purposes, to develop, compile, test and distribute Your Source and Output.
>
> **4. Your Source and Output (runtime library exception).** Your Source is
> yours; this licence claims no rights in it. The RIINA Authors grant you a
> perpetual, worldwide, royalty-free, irrevocable licence to use, copy, modify
> and distribute Output, including the Runtime Library as it appears in
> Output, under terms of your choice. This section survives any termination
> of this licence and does not depend on your compliance with sections 5 to 8
> after the Output was produced.
>
> **5. Restrictions.** Except as sections 2 to 4 and 8 allow, you may not:
> (a) distribute, sublicense, sell, lease or lend the Compiler, or a modified
> version of it, to a third party;
> (b) modify the Compiler, except locally to build, test, audit or prepare a
> contribution under section 8;
> (c) remove or alter copyright, licence or trademark notices;
> (d) [OWNER CHOICE — keep, narrow or drop] distribute a product derived from
> the Compiler's source code that competes with the Compiler.
>
> **6. Formal proofs and specifications.** You may use the formal proofs and
> language specifications for verification, audit, research and teaching.
> [OWNER CHOICE: whether they may also be used to build an independent
> implementation of the RIINA language.]
>
> **7. Continuity.** [OWNER CHOICE — one or more of the mechanisms in Draft 3.]
>
> **8. Contributions.** If you submit a contribution, you agree to the terms
> in `CONTRIBUTING.md` [CLA or DCO — owner choice], which say what rights you
> grant in it.
>
> **9. Trademarks.** This licence grants no right to use the RIINA name or
> logo, except as `TRADEMARK.md` allows.
>
> **10. Termination.** If you breach this licence and do not cure the breach
> within 30 days of written notice, your rights under sections 2, 3, 5 and 6
> end. Section 4 and Draft 3's perpetual grant for versions already received
> are not affected.
>
> **11. Disclaimer of warranty.** [unchanged from version 1]
>
> **12. Limitation of liability.** [unchanged from version 1]
>
> **13. Governing law.** This licence is governed by the laws of Malaysia.
>
> **14. Contact.** [a durable channel: a project email address or the GitHub
> repository's security advisory and discussion pages, not a personal
> messaging link].

---

## Draft 2 — RIINA Runtime Library Exception (standalone form)

Use this form if the owner prefers to keep `LICENSE` version 1 and add the
exception beside it. It plays the same role as the GCC Runtime Library
Exception.

> RIINA RUNTIME LIBRARY EXCEPTION, version 1 (draft)
>
> This exception is an additional permission under the RIINA licence. It
> applies to the Runtime Library: the code that the RIINA compiler copies,
> embeds or generates into the files it produces from a user's program.
>
> When the RIINA compiler produces a file from your program, The RIINA
> Authors grant you a perpetual, worldwide, royalty-free and irrevocable
> licence to use, copy, modify and distribute that file, including the
> Runtime Library it contains, under terms of your choice. The grant does not
> end if the RIINA licence is revoked, terminated or replaced, and it does
> not extend to the RIINA compiler itself.

---

## Draft 3 — Continuity mechanisms (pick at least one)

**3(a) Perpetual licence to versions received.**

> The rights in sections 2, 3 and 6 for any version of the Compiler you have
> lawfully received are perpetual and irrevocable, except under section 10.

**3(b) Delayed open-source change date (BSL-1.1 style).**

> Each released version of the Compiler is also licensed to you under the
> Apache License, Version 2.0, from the earlier of: (i) [N] years after that
> version's release date; or (ii) the day [18] months pass with no new
> release published by The RIINA Authors.

**3(c) Source-code escrow.** A third-party escrow agent holds the complete
source, build instructions and proof corpus for each release. It releases
them to registered licensees under [Apache-2.0 / the version 2 licence
without section 5] if: there is no release for [18] months; The RIINA Authors
become insolvent or are wound up; or The RIINA Authors announce the end of
maintenance. Counsel and the escrow agent supply the agreement. The repository
already builds an escrow bundle (`scripts/build-escrow-bundle.sh`), which can
be the deposit format.

---

## Draft 4 — `TRADEMARK.md` (trademark policy)

> RIINA TRADEMARK POLICY (draft)
>
> "RIINA" and the RIINA logo are trademarks of The RIINA Authors [registration
> status: owner to state; until registration, use ™, not ®]. This policy
> applies whatever licence covers the code.
>
> You may, without asking:
> - say truthfully that your software is written in RIINA or built with the
>   RIINA compiler;
> - refer to RIINA by name in articles, books, courses, audit reports and
>   talks;
> - use the name in a package or module name that makes clear it is not
>   official, for example `riina-community-foo`.
>
> You may not, without written permission:
> - use RIINA, or a confusingly similar name or logo, as the name of a
>   compiler, language implementation, fork or verification service;
> - suggest that The RIINA Authors endorse or certify your product or audit,
>   unless they do;
> - use the logo except unmodified, to refer to the project.
>
> A modified or forked compiler must use a different name.
>
> Questions: [contact].

---

## Notes for counsel

1. **Section 4 / Draft 2 versus termination.** Version 1 makes the whole
   licence revocable and requires destroying "all copies of the RIINA
   compiler" on termination. The embedded runtime code sits in users'
   binaries. The drafts make the output grant irrevocable and say so
   explicitly. Please confirm this is effective under Malaysian law.
2. **GitHub Terms of Service.** A public repository lets other GitHub users
   view and fork it on GitHub (GitHub Terms of Service, section D.5). Version
   1 restrictions (a), (b) and (e) contradict that while the source is
   public. Draft section 2 removes the contradiction for viewing, cloning and
   building. Please advise whether forking on GitHub also needs an explicit
   carve-out.
3. **Clause (e) of version 1** ("access or attempt to access the source code")
   cannot be complied with by anyone reading the public repository. Every
   draft drops it.
4. **Competing-product clause (version 1 (d)).** As written, it reaches anyone
   who builds "a verification platform", which may include auditors' own
   tools. The draft narrows it to distributing a competing product derived
   from the Compiler's source; the owner may drop it.
5. **Inbound licence.** `CONTRIBUTING.md` says contributions "will be licensed
   under the RIINA Proprietary License". That is an outbound licence from the
   authors to users, so it does not give The RIINA Authors any rights in a
   contribution. A CLA (a licence grant to The RIINA Authors) fits a
   proprietary model better than a DCO, which only certifies origin.
6. **Third-party code.** The compiler workspace (`03_PROTO`) has no external
   dependencies. The tooling workspace (`05_TOOLING`) has 121, all under
   permissive licences (MIT, Apache-2.0, BSD-2-Clause, Unlicense,
   Unicode-3.0), one of them dual-licensed with LGPL-2.1-or-later as an
   alternative. See `sbom/riina-tooling.cdx.json`. Please confirm notice
   obligations if any tooling binary is distributed.
