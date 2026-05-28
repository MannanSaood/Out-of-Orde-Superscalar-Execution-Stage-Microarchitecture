# Out-of-Order (OoO) Superscalar Execution Stage

## 1. Microarchitecture & Specifications
This project isolates and designs the control heart of a high-performance microprocessor: resolving register dependencies dynamically to issue instructions out-of-order, while maintaining strict in-order retirement.

- **Register Rename Unit (RAT / FRAT)**: Decouples 32 architectural registers (r0–r31) by mapping them to an expanded physical register file of 64 physical registers (p0–p63). A bit-masked Free List FIFO tracks available registers and allocates a physical tag on every instruction dispatch.
- **Unified Reservation Station (Issue Queue)**: An 8-entry instruction window holding dispatched instructions. It dynamically monitors an internal 64-bit hardware wakeup bus. When execution units broadcast target physical tags, the respective source tag valid bits flip asynchronously.
- **Matrix-Based Age Arbiter Reorder Buffer (ROB)**: A circular 16-entry ROB tracks instruction speculative states. A triangular age matrix prioritizes the execution of older ready instructions over newer ones to prevent execution starvation.

## 2. Implementation Milestones
- **Weeks 1–3 (Rename Block)**: Implement the FRAT lookup array, mapping checkpoints, and the Free List allocator stack.
- **Weeks 4–6 (Issue Window)**: Design the reservation station queues, implementing the tag-matching bus monitoring logic and the age-priority matrix.
- **Weeks 7–9 (Retirement ROB)**: Code the circular ROB, supporting precise exception rollback logic and flash-clear rollback controls.

## 3. Advanced Validation Techniques
- **Speculative Rollback Recovery Stress Testing**: Build targeted test sequences (using **Verilator** or commercial simulators) designed to inject dependent instruction chains, trigger branch mispredictions during mid-execution, and verify that the rename unit rolls back to its retirement map snapshot without leaking a single register map pointer.
- **Structural Hazard Coverage**: Force structural bottlenecking by driving cases where the Issue Queue is saturated, the Free List is depleted, and the execution pipes are stalled. The verification environment must prove that the dispatch stage halts instruction flow instantly and resumes without instruction loss.
- **Physical Register Lifecycle Assertion**: Write a formal SVA mapping register allocations:
  ```systemverilog
  assert property (@(posedge clk)
    (physical_reg_allocated) |-> !physical_reg_free UNTIL physical_reg_retired);
  ```
  This mathematically guarantees that no physical register is returned to the Free List while active instructions are still dependent on its output.

## 4. Current Execution Status
- **Phase 1 & 2 Modules Completed**: `free_list.sv`, `frat.sv`, `rename_unit.sv`, `reservation_station.sv`, `wakeup_bus.sv`, `age_matrix_arbiter.sv`.

### Functional Verification
- **Framework**: Vivado XSim (`xelab`)
- **Coverage**: Basic functional validation via directed testbenches.
- **Status**: `[PASS]` (0 Errors, 0 Warnings) for `tb_reservation_station`.

### Hardware Synthesis (PPA Metrics)
- **Target Architecture**: Xilinx Artix-7 (`xc7a35tcpg236-1`)
- **Tool**: Vivado 2024.2 Synthesis (`synth_design`)

| Metric | Resource | Value | Utilization |
| :--- | :--- | :--- | :--- |
| **Area** | Slice LUTs | 343 | 1.65% |
| **Area** | Slice Registers | 595 | 1.43% |
| **Timing** | Fmax | Unconstrained | N/A |
