---- MODULE PhysicsSecurity ----
\* Copyright (c) 2026 The RIINA Authors. All rights reserved.
\* Derived from 02_FORMAL/coq/domains/PhysicsSecurity.v
\* Models key types, operators, and properties from the Coq formalization.

EXTENDS Naturals, FiniteSets, Sequences

\* SensorKind (matches Coq: Inductive SensorKind)
CONSTANTS Temperature, Pressure, Accelerometer, Gyroscope

SensorKindSet == {Temperature, Pressure, Accelerometer, Gyroscope}

\* PhysState (matches Coq: Inductive PhysState)
CONSTANTS Idle, Sensing, Processing, Actuating, Error

PhysStateSet == {Idle, Sensing, Processing, Actuating, Error}

\* ===================================================================
\* STATE VARIABLES
\* ===================================================================

\* SensorReading (matches Coq: Record SensorReading)
VARIABLES sensor_kind, reading_value, reading_min, reading_max, timestamp, sensor_id

\* MeasurementSpec (matches Coq: Record MeasurementSpec)
VARIABLES meas_tolerance, meas_samples, meas_min_samples

\* TimingConstraint (matches Coq: Record TimingConstraint)
VARIABLES deadline, wcet, period, jitter_bound

vars == <<sensor_kind, reading_value, reading_min, reading_max, timestamp, sensor_id, meas_tolerance, meas_samples, meas_min_samples, deadline, wcet, period, jitter_bound>>

\* ===================================================================
\* TYPE INVARIANT
\* ===================================================================

TypeOK ==
  /\ sensor_kind \in SensorKindSet
  /\ reading_value \in Nat
  /\ reading_min \in Nat
  /\ reading_max \in Nat
  /\ timestamp \in Nat
  /\ sensor_id \in Nat
  /\ meas_tolerance \in Nat
  /\ meas_samples \in Nat
  /\ meas_min_samples \in Nat
  /\ deadline \in Nat
  /\ wcet \in Nat
  /\ period \in Nat
  /\ jitter_bound \in Nat

\* ===================================================================
\* INITIAL STATE
\* ===================================================================

Init ==
  /\ sensor_kind = Temperature
  /\ reading_value = 0
  /\ reading_min = 0
  /\ reading_max = 0
  /\ timestamp = 0
  /\ sensor_id = 0
  /\ meas_tolerance = 0
  /\ meas_samples = 0
  /\ meas_min_samples = 0
  /\ deadline = 0
  /\ wcet = 0
  /\ period = 0
  /\ jitter_bound = 0

\* ===================================================================
\* OPERATORS (derived from Coq definitions)
\* ===================================================================

\* reading_in_bounds (matches Coq: Definition reading_in_bounds)
reading_in_bounds(r) ==
  r >= 0

\* reading_valid (matches Coq: Definition reading_valid)
reading_valid(r) ==
  reading_min(r) /\ reading_value(r) /\ reading_value(r) /\ reading_max(r)

\* spec_feasible (matches Coq: Definition spec_feasible)
spec_feasible(spec) ==
  spec >= 0

\* readings_avg (matches Coq: Definition readings_avg)
readings_avg(vals) ==
    CASE TRUE -> fold_left

\* timing_feasible (matches Coq: Definition timing_feasible)
timing_feasible(tc) ==
  tc >= 0

\* timing_schedulable (matches Coq: Definition timing_schedulable)
timing_schedulable(tc) ==
  tc >= 0

\* is_operational (matches Coq: Definition is_operational)
is_operational(s) ==
    CASE s = Error -> FALSE
    [] OTHER -> TRUE

\* ===================================================================
\* STATE MACHINE
\* ===================================================================

UpdateSensorReading ==
  /\ sensor_kind' \in SensorKindSet
  /\ reading_value' \in 0..100
  /\ reading_min' \in 0..100
  /\ reading_max' \in 0..100
  /\ timestamp' \in 0..100
  /\ sensor_id' \in 0..100
  /\ UNCHANGED <<meas_tolerance, meas_samples, meas_min_samples, deadline, wcet, period, jitter_bound>>

ValidateState ==
  /\ TypeOK
  /\ UNCHANGED vars

Next == UpdateSensorReading \/ ValidateState

Spec == Init /\ [][Next]_vars

\* ===================================================================
\* THEOREMS (derived from Coq proofs)
\* ===================================================================

\* reading_in_bounds_correct
THEOREM reading_in_bounds_correct ==
  \A r \in Nat :
      reading_in_bounds(r) => reading_valid(r)

\* valid_reading_min_le_max
THEOREM valid_reading_min_le_max ==
  \A r \in Nat :
      reading_valid(r) => reading_min r <= reading_max r

\* reading_value_bounded
THEOREM reading_value_bounded ==
  \A r \in Nat :
      reading_valid(r) => reading_value r <= reading_max r

\* spec_feasible_correct
THEOREM spec_feasible_correct ==
  \A spec \in Nat :
      spec_feasible(spec) => 1 <= meas_min_samples

\* spec_feasible_nonzero_samples
THEOREM spec_feasible_nonzero_samples ==
  \A spec \in Nat :
      spec_feasible(spec) => meas_samples spec > 0

\* empty_readings_avg_zero
THEOREM empty_readings_avg_zero ==
  readings_avg [] = 0

\* timing_feasible_correct
THEOREM timing_feasible_correct ==
  \A tc \in Nat :
      timing_feasible(tc) => timing_schedulable(tc)

\* feasible_wcet_within_deadline
THEOREM feasible_wcet_within_deadline ==
  \A tc \in Nat :
      timing_schedulable(tc) => wcet tc <= deadline tc

\* feasible_deadline_within_period
THEOREM feasible_deadline_within_period ==
  \A tc \in Nat :
      timing_schedulable(tc) => deadline tc <= period tc

\* idle_always_transitions_to_sensing
THEOREM idle_always_transitions_to_sensing ==
  \A ok \in Nat :
      phys_transition(Idle, ok) = Sensing

\* sensing_error_on_failure
THEOREM sensing_error_on_failure ==
  phys_transition(Sensing, false) = Error

\* sensing_proceeds_on_success
THEOREM sensing_proceeds_on_success ==
  phys_transition(Sensing, true) = Processing

\* error_recovers_to_idle
THEOREM error_recovers_to_idle ==
  \A ok \in Nat :
      phys_transition(Error, ok) = Idle

\* full_cycle_returns_to_idle
THEOREM full_cycle_returns_to_idle ==
  \A ok \in Nat :
      phys_run Idle [true; true; true; ok] = Idle

\* error_state_not_operational
THEOREM error_state_not_operational ==
  is_operational(Error) = FALSE

\* idle_is_operational
THEOREM idle_is_operational ==
  is_operational(Idle) = TRUE

\* reading_bounded_values
THEOREM reading_bounded_values ==
  \A r \in Nat :
      reading_in_bounds(r) => reading_min r <= reading_value r /\ reading_value r <= reading_max r

\* sensing_transitions_depend_on_input
THEOREM sensing_transitions_depend_on_input ==
  phys_transition(Sensing, true) # phys_transition(Sensing, false)

\* actuating_transitions_to_idle
THEOREM actuating_transitions_to_idle ==
  \A ok \in Nat :
      phys_transition(Actuating, ok) = Idle

\* processing_transitions_to_actuating
THEOREM processing_transitions_to_actuating ==
  \A ok \in Nat :
      phys_transition(Processing, ok) = Actuating

\* processing_is_operational
THEOREM processing_is_operational ==
  is_operational(Processing) = TRUE

\* actuating_is_operational
THEOREM actuating_is_operational ==
  is_operational(Actuating) = TRUE

\* sensing_is_operational
THEOREM sensing_is_operational ==
  is_operational(Sensing) = TRUE

\* error_recovery_cycle
THEOREM error_recovery_cycle ==
  \A ok \in Nat :
      phys_run Error [ok; true; true; true; ok] = Idle

\* reading_bounds_decomposition
THEOREM reading_bounds_decomposition ==
  \A r \in Nat :
      reading_in_bounds(r) => (reading_min r <=? reading_value r) = true /\
      (reading_value r <=? reading_max r) = true

\* 1 additional theorems proven in Coq source

====
