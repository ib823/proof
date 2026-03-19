You are Codex running non-interactively inside `/workspaces/proof`.

Mission:
Close one RIINA domain audit cycle by reconciling the primary audit to the hostile review, updating the audit-control artifacts, and creating or refreshing remediation docs.

Target domain:
- Domain ID: `__DOMAIN_ID__`
- Pinned current commit: `__CURRENT_COMMIT__`
- Primary audit path: `__AUDIT_PATH__`
- Hostile review path: `__REVIEW_PATH__`

Mandatory authority files to read first, in this exact order:
1. `RIINA_MASTER_PLAN.md`
2. `CLAUDE.md`
3. `AGENTS.md`
4. `04_SPECS/cross-cutting/DOMAIN_R5_CHECKLIST_v1_0_0.md`
5. `04_SPECS/cross-cutting/DOMAIN_R5_WORKSHEET_TEMPLATE_v1_0_0.md`
6. `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`
7. `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`
8. `__AUDIT_PATH__`
9. `__REVIEW_PATH__`

Non-negotiable rules:
1. Run and record:
   - `git status --short --branch`
   - `git rev-parse HEAD`
2. If `HEAD` is not exactly `__CURRENT_COMMIT__`, stop and report snapshot drift.
3. If `__REVIEW_PATH__` is missing, stop and report the cycle incomplete.
4. If the hostile review says the review is invalid due to material evidence drift, stop and report the cycle blocked.
5. Do not edit `RIINA_MASTER_PLAN.md`.
6. Do not start a new audit in this run.
7. Do not change domain implementation, proofs, examples, or metrics in this run.
8. Reconcile the audit downward whenever the review is stricter.
9. If the review is materially wrong and the audit evidence clearly disproves it, document that explicitly and keep the safer wording.

Required outputs in this run:
1. Reconcile `__AUDIT_PATH__` to the reviewer-safe rating, gate scores, and safe/unsafe claims.
2. Update `06_COORDINATION/audit_outputs/domain_r5/AUDIT_PROGRAM_STATUS_v1_0_0.md`:
   - set `Hostile review artifact` to `__REVIEW_PATH__`
   - set `Audit reconciled in repo?` to `Yes`
   - set `Current honest rating in repo` to the final reconciled rating
   - set `Current status` to `CLOSED` unless the review proves the domain should remain open
   - set `Remediation package?` to the remediation README path if created
3. Update `06_COORDINATION/prompts/DOMAIN_AUDIT_QUEUE_v1_0_0.md`:
   - change `__DOMAIN_ID__` from `DONE_AUDIT_ONLY` to `DONE_REVIEWED`
4. Create or refresh the remediation package under `06_COORDINATION/remediation/__DOMAIN_ID__/`.

Remediation package requirements:
1. Always create:
   - `06_COORDINATION/remediation/__DOMAIN_ID__/README.md`
   - `06_COORDINATION/remediation/__DOMAIN_ID__/__DOMAIN_ID___REMEDIATION_PLAN_v1_0_0.md`
   - `06_COORDINATION/remediation/__DOMAIN_ID__/__DOMAIN_ID___R1_TO_R5_WORKLIST_v1_0_0.md`
2. If the domain obviously needs child-domain decomposition, also create:
   - `06_COORDINATION/remediation/__DOMAIN_ID__/__DOMAIN_ID___CHILD_DOMAIN_BREAKDOWN_v1_0_0.md`
3. If the review and audit clearly identify one first flagship vertical, also create one first-target spec named:
   - `06_COORDINATION/remediation/__DOMAIN_ID__/__DOMAIN_ID___<TARGET>_R5_TARGET_SPEC_v1_0_0.md`
4. Remediation docs must be conservative, specific, and tied to the audit and review artifacts.

Reconciliation procedure:
1. Compare the audit and review gate-by-gate.
2. Downgrade any audit rating or gate score the review justifiably attacked.
3. Reduce public wording to the weakest safe claim.
4. Preserve exact file references and commands.
5. Do not erase the audit history; reconcile it.
6. Make the remediation package match the final in-repo rating, not the earlier optimistic one.
7. Ensure the audit artifact ends with a `Next Audit Handoff` block naming the next recommended domain after this one.

Final response requirements:
1. State that `__DOMAIN_ID__` was reconciled.
2. State the final rating in repo.
3. State the remediation README path.
4. State that the queue and tracker were updated.
