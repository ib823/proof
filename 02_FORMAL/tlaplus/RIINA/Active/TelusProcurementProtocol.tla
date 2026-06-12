---- MODULE TelusProcurementProtocol ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Manually maintained Phase 2 smoke model for REQ-09.
\* Scope: bounded procurement protocol slice derived from
\* 01_RESEARCH/56_DOMAIN_AK_VERIFIED_PROCUREMENT/RESEARCH_AK01_PROCUREMENT_STATE_MACHINES.md
\* This file is intentionally small, finite, and TLC-checkable.

EXTENDS Naturals

CONSTANTS
  MinBids,
  MaxBids,
  Requester,
  BudgetOfficer,
  ProcurementOfficer,
  EvaluationChair,
  AwardAuthority

PhaseSet ==
  {
    "Draft",
    "Planning",
    "BudgetApproved",
    "TenderOpen",
    "Evaluation",
    "Award",
    "Contract",
    "Failed",
    "Cancelled"
  }

Actors == {Requester, BudgetOfficer, ProcurementOfficer, EvaluationChair, AwardAuthority}

VARIABLES
  phase,
  bidsReceived,
  budgetApproved,
  evaluationComplete,
  standstillElapsed,
  challengeFiled,
  contractSigned

vars ==
  << phase,
     bidsReceived,
     budgetApproved,
     evaluationComplete,
     standstillElapsed,
     challengeFiled,
     contractSigned >>

TypeOK ==
  /\ phase \in PhaseSet
  /\ bidsReceived \in 0..MaxBids
  /\ budgetApproved \in BOOLEAN
  /\ evaluationComplete \in BOOLEAN
  /\ standstillElapsed \in BOOLEAN
  /\ challengeFiled \in BOOLEAN
  /\ contractSigned \in BOOLEAN
  /\ MinBids \in Nat
  /\ MaxBids \in Nat
  /\ MinBids >= 1
  /\ MaxBids >= MinBids

RoleSeparation ==
  /\ Requester /= BudgetOfficer
  /\ Requester /= ProcurementOfficer
  /\ Requester /= EvaluationChair
  /\ Requester /= AwardAuthority
  /\ BudgetOfficer /= ProcurementOfficer
  /\ BudgetOfficer /= EvaluationChair
  /\ BudgetOfficer /= AwardAuthority
  /\ ProcurementOfficer /= EvaluationChair
  /\ ProcurementOfficer /= AwardAuthority
  /\ EvaluationChair /= AwardAuthority

TenderRequiresBudget ==
  phase \in {"TenderOpen", "Evaluation", "Award", "Contract"} => budgetApproved

AwardNeedsEvaluation ==
  phase \in {"Award", "Contract"} => evaluationComplete

AwardNeedsCompetition ==
  phase \in {"Award", "Contract"} => bidsReceived >= MinBids

ContractNeedsStandstill ==
  contractSigned => /\ phase = "Contract"
                    /\ standstillElapsed
                    /\ ~challengeFiled
                    /\ evaluationComplete

Init ==
  /\ phase = "Draft"
  /\ bidsReceived = 0
  /\ budgetApproved = FALSE
  /\ evaluationComplete = FALSE
  /\ standstillElapsed = FALSE
  /\ challengeFiled = FALSE
  /\ contractSigned = FALSE

StartPlanning ==
  /\ phase = "Draft"
  /\ phase' = "Planning"
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

ApproveBudget ==
  /\ phase = "Planning"
  /\ phase' = "BudgetApproved"
  /\ budgetApproved' = TRUE
  /\ UNCHANGED << bidsReceived,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

PublishTender ==
  /\ phase = "BudgetApproved"
  /\ phase' = "TenderOpen"
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

ReceiveBid ==
  /\ phase = "TenderOpen"
  /\ bidsReceived < MaxBids
  /\ phase' = "TenderOpen"
  /\ bidsReceived' = bidsReceived + 1
  /\ UNCHANGED << budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

CloseTenderSuccess ==
  /\ phase = "TenderOpen"
  /\ bidsReceived >= MinBids
  /\ phase' = "Evaluation"
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

CloseTenderFailure ==
  /\ phase = "TenderOpen"
  /\ bidsReceived < MinBids
  /\ phase' = "Failed"
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

FinalizeEvaluation ==
  /\ phase = "Evaluation"
  /\ phase' = "Award"
  /\ evaluationComplete' = TRUE
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

ExpireStandstill ==
  /\ phase = "Award"
  /\ ~standstillElapsed
  /\ phase' = "Award"
  /\ standstillElapsed' = TRUE
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  challengeFiled,
                  contractSigned >>

FileChallenge ==
  /\ phase = "Award"
  /\ ~challengeFiled
  /\ phase' = "Cancelled"
  /\ challengeFiled' = TRUE
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  contractSigned >>

SignContract ==
  /\ phase = "Award"
  /\ standstillElapsed
  /\ ~challengeFiled
  /\ phase' = "Contract"
  /\ contractSigned' = TRUE
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled >>

CancelProcurement ==
  /\ phase \notin {"Contract", "Failed", "Cancelled"}
  /\ phase' = "Cancelled"
  /\ UNCHANGED << bidsReceived,
                  budgetApproved,
                  evaluationComplete,
                  standstillElapsed,
                  challengeFiled,
                  contractSigned >>

TerminalStutter ==
  /\ phase \in {"Contract", "Failed", "Cancelled"}
  /\ UNCHANGED vars

Next ==
  \/ StartPlanning
  \/ ApproveBudget
  \/ PublishTender
  \/ ReceiveBid
  \/ CloseTenderSuccess
  \/ CloseTenderFailure
  \/ FinalizeEvaluation
  \/ ExpireStandstill
  \/ FileChallenge
  \/ SignContract
  \/ CancelProcurement
  \/ TerminalStutter

Spec == Init /\ [][Next]_vars

THEOREM TPP_001_role_separation == RoleSeparation
THEOREM TPP_002_tender_requires_budget == TenderRequiresBudget
THEOREM TPP_003_award_requires_evaluation == AwardNeedsEvaluation
THEOREM TPP_004_award_requires_competition == AwardNeedsCompetition
THEOREM TPP_005_contract_requires_standstill == ContractNeedsStandstill

====
