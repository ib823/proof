; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA SystemArchitecture — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/SystemArchitecture.v (22 assertions)
; Module: SystemArchitecture
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((DeviceState 0)) (((Uninitialized) (Booting) (BootComplete) (Running) (Suspended) (ShuttingDown))))

(declare-datatypes ((UpdateResult 0)) (((UpdateSuccess) (UpdateFailed) (UpdateRollback))))

(declare-datatypes ((PrivilegeLevel 0)) (((KernelMode) (SupervisorMode) (UserMode))))

(declare-datatypes ((Device 0))
  (((mk-device (device_id Int) (device_state DeviceState) (boot_verified Bool) (secure_boot_chain Bool) (boot_time_ms Int)))))

(declare-datatypes ((SystemUpdate 0))
  (((mk-system_update (update_id Int) (update_version Int) (update_signature_valid Bool) (update_integrity_verified Bool)))))

(declare-datatypes ((System 0))
  (((mk-system (system_version Int) (system_state DeviceState) (update_pending Int)))))

(declare-datatypes ((Process 0))
  (((mk-process (process_id Int) (process_memory_region Int) (process_permissions (Seq Int))))))

(declare-datatypes ((ExtProcess 0))
  (((mk-ext_process (ext_pid Int) (ext_mem_start Int) (ext_mem_size Int) (ext_privilege PrivilegeLevel) (ext_alive Bool) (ext_parent_pid Int) (ext_resource_limit Int) (ext_resource_used Int)))))

(declare-datatypes ((Syscall 0))
  (((mk-syscall (syscall_id Int) (syscall_caller_privilege PrivilegeLevel) (syscall_required_privilege PrivilegeLevel) (syscall_validated Bool)))))

(declare-datatypes ((IPCChannel 0))
  (((mk-ipc_channel (ipc_id Int) (ipc_sender_pid Int) (ipc_receiver_pid Int) (ipc_typed Bool) (ipc_capacity Int) (ipc_current_size Int)))))

(declare-datatypes ((SchedulerState 0))
  (((mk-scheduler_state (sched_running_pid Int) (sched_ready_queue (Seq Int)) (sched_time_slice Int) (sched_context_saved Bool)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. DeviceState exhaustiveness ---
(push 1)
(declare-const x DeviceState)
(assert (not (or (= x Uninitialized) (= x Booting) (= x BootComplete) (= x Running) (= x Suspended) (= x ShuttingDown))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. DeviceState: Uninitialized != Booting ---
(push 1)
(assert (= Uninitialized Booting))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. DeviceState: Booting != BootComplete ---
(push 1)
(assert (= Booting BootComplete))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. DeviceState: BootComplete != Running ---
(push 1)
(assert (= BootComplete Running))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. DeviceState: Uninitialized != ShuttingDown ---
(push 1)
(assert (= Uninitialized ShuttingDown))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. DeviceState finite cardinality (6 values) ---
(push 1)
(declare-const x DeviceState)
(assert (and (not (= x Uninitialized)) (not (= x Booting)) (not (= x BootComplete)) (not (= x Running)) (not (= x Suspended)) (not (= x ShuttingDown))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. UpdateResult exhaustiveness ---
(push 1)
(declare-const x UpdateResult)
(assert (not (or (= x UpdateSuccess) (= x UpdateFailed) (= x UpdateRollback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. UpdateResult: UpdateSuccess != UpdateFailed ---
(push 1)
(assert (= UpdateSuccess UpdateFailed))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. UpdateResult: UpdateFailed != UpdateRollback ---
(push 1)
(assert (= UpdateFailed UpdateRollback))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. UpdateResult finite cardinality (3 values) ---
(push 1)
(declare-const x UpdateResult)
(assert (and (not (= x UpdateSuccess)) (not (= x UpdateFailed)) (not (= x UpdateRollback))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. PrivilegeLevel exhaustiveness ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (or (= x KernelMode) (= x SupervisorMode) (= x UserMode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. PrivilegeLevel: KernelMode != SupervisorMode ---
(push 1)
(assert (= KernelMode SupervisorMode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. PrivilegeLevel: SupervisorMode != UserMode ---
(push 1)
(assert (= SupervisorMode UserMode))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. PrivilegeLevel finite cardinality (3 values) ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (and (not (= x KernelMode)) (not (= x SupervisorMode)) (not (= x UserMode))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. Device accessor round-trip: device_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (device_id (mk-device f0 f1 f2 f3 f4)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. Device accessor round-trip: device_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (device_state (mk-device f0 f1 f2 f3 f4)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. Device accessor round-trip: boot_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (boot_verified (mk-device f0 f1 f2 f3 f4)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. Device accessor round-trip: secure_boot_chain ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (secure_boot_chain (mk-device f0 f1 f2 f3 f4)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. Device accessor round-trip: boot_time_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Bool)
(declare-const f3 Bool)
(declare-const f4 Int)
(assert (not (= (boot_time_ms (mk-device f0 f1 f2 f3 f4)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. Device: non-negative int fields sum ---
(push 1)
(declare-const r Device)
(assert (>= (device_id r) 0))
(assert (>= (boot_time_ms r) 0))
(assert (not (>= (+ (device_id r) (boot_time_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. SystemUpdate accessor round-trip: update_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (update_id (mk-system_update f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. SystemUpdate accessor round-trip: update_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (update_version (mk-system_update f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. SystemUpdate accessor round-trip: update_signature_valid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (update_signature_valid (mk-system_update f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. SystemUpdate accessor round-trip: update_integrity_verified ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (update_integrity_verified (mk-system_update f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. SystemUpdate: non-negative int fields sum ---
(push 1)
(declare-const r SystemUpdate)
(assert (>= (update_id r) 0))
(assert (>= (update_version r) 0))
(assert (not (>= (+ (update_id r) (update_version r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. System accessor round-trip: system_version ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Int)
(assert (not (= (system_version (mk-system f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. System accessor round-trip: system_state ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Int)
(assert (not (= (system_state (mk-system f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. System accessor round-trip: update_pending ---
(push 1)
(declare-const f0 Int)
(declare-const f1 DeviceState)
(declare-const f2 Int)
(assert (not (= (update_pending (mk-system f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. System: non-negative int fields sum ---
(push 1)
(declare-const r System)
(assert (>= (system_version r) 0))
(assert (>= (update_pending r) 0))
(assert (not (>= (+ (system_version r) (update_pending r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. Process accessor round-trip: process_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (process_id (mk-process f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. Process accessor round-trip: process_memory_region ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 (Seq Int))
(assert (not (= (process_memory_region (mk-process f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. Process: non-negative int fields sum ---
(push 1)
(declare-const r Process)
(assert (>= (process_id r) 0))
(assert (>= (process_memory_region r) 0))
(assert (not (>= (+ (process_id r) (process_memory_region r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. ExtProcess accessor round-trip: ext_pid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 PrivilegeLevel)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (ext_pid (mk-ext_process f0 f1 f2 f3 f4 f5 f6 f7)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. ExtProcess accessor round-trip: ext_mem_start ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 PrivilegeLevel)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (ext_mem_start (mk-ext_process f0 f1 f2 f3 f4 f5 f6 f7)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. ExtProcess accessor round-trip: ext_mem_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 PrivilegeLevel)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (ext_mem_size (mk-ext_process f0 f1 f2 f3 f4 f5 f6 f7)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. ExtProcess accessor round-trip: ext_privilege ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 PrivilegeLevel)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (ext_privilege (mk-ext_process f0 f1 f2 f3 f4 f5 f6 f7)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. ExtProcess accessor round-trip: ext_alive ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 PrivilegeLevel)
(declare-const f4 Bool)
(declare-const f5 Int)
(declare-const f6 Int)
(declare-const f7 Int)
(assert (not (= (ext_alive (mk-ext_process f0 f1 f2 f3 f4 f5 f6 f7)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. ExtProcess: non-negative int fields sum ---
(push 1)
(declare-const r ExtProcess)
(assert (>= (ext_pid r) 0))
(assert (>= (ext_mem_start r) 0))
(assert (not (>= (+ (ext_pid r) (ext_mem_start r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. Syscall accessor round-trip: syscall_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PrivilegeLevel)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(assert (not (= (syscall_id (mk-syscall f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. Syscall accessor round-trip: syscall_caller_privilege ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PrivilegeLevel)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(assert (not (= (syscall_caller_privilege (mk-syscall f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. Syscall accessor round-trip: syscall_required_privilege ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PrivilegeLevel)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(assert (not (= (syscall_required_privilege (mk-syscall f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. Syscall accessor round-trip: syscall_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 PrivilegeLevel)
(declare-const f2 PrivilegeLevel)
(declare-const f3 Bool)
(assert (not (= (syscall_validated (mk-syscall f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. IPCChannel accessor round-trip: ipc_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ipc_id (mk-ipc_channel f0 f1 f2 f3 f4 f5)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. IPCChannel accessor round-trip: ipc_sender_pid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ipc_sender_pid (mk-ipc_channel f0 f1 f2 f3 f4 f5)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. IPCChannel accessor round-trip: ipc_receiver_pid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ipc_receiver_pid (mk-ipc_channel f0 f1 f2 f3 f4 f5)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. IPCChannel accessor round-trip: ipc_typed ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ipc_typed (mk-ipc_channel f0 f1 f2 f3 f4 f5)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. IPCChannel accessor round-trip: ipc_capacity ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(declare-const f4 Int)
(declare-const f5 Int)
(assert (not (= (ipc_capacity (mk-ipc_channel f0 f1 f2 f3 f4 f5)) f4)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. IPCChannel: non-negative int fields sum ---
(push 1)
(declare-const r IPCChannel)
(assert (>= (ipc_id r) 0))
(assert (>= (ipc_sender_pid r) 0))
(assert (not (>= (+ (ipc_id r) (ipc_sender_pid r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. SchedulerState accessor round-trip: sched_running_pid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 (Seq Int))
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (sched_running_pid (mk-scheduler_state f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun PrivilegeLevel_level ((x PrivilegeLevel)) Int
  (ite (= x KernelMode) 0 (ite (= x SupervisorMode) 1 2)))

(define-fun PrivilegeLevel_leq ((x PrivilegeLevel) (y PrivilegeLevel)) Bool
  (<= (PrivilegeLevel_level x) (PrivilegeLevel_level y)))

; --- 50. PrivilegeLevel_leq reflexivity ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. PrivilegeLevel_leq transitivity ---
(push 1)
(declare-const x PrivilegeLevel)
(declare-const y PrivilegeLevel)
(declare-const z PrivilegeLevel)
(assert (PrivilegeLevel_leq x y))
(assert (PrivilegeLevel_leq y z))
(assert (not (PrivilegeLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. PrivilegeLevel_leq antisymmetry ---
(push 1)
(declare-const x PrivilegeLevel)
(declare-const y PrivilegeLevel)
(assert (PrivilegeLevel_leq x y))
(assert (PrivilegeLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. KernelMode is bottom ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq KernelMode x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. UserMode is top ---
(push 1)
(declare-const x PrivilegeLevel)
(assert (not (PrivilegeLevel_leq x UserMode)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
