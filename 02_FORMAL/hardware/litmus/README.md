# RIINA Hardware Litmus Suite

This folder contains minimal architecture-level litmus cases used by
Dimension 13 gates (`check-heavy-closure.sh`) to ensure explicit hardware
assumption artifacts exist in the repository.

These tests are intentionally small and target memory-ordering and
speculation-relevant behavior:

- `store_buffering_litmus.txt`
- `load_buffering_litmus.txt`
- `x86_memory_order_litmus.txt`

The suite is a baseline artifact set; executable model-check integration is
tracked separately in heavy-closure follow-up work.
