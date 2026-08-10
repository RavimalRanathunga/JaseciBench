## Issues
- None.

## Learnings
- `jac test` with no args may collect 0 items in this project; target the specific .jac test file (e.g. `jac test tests/baseline.jac`).

## Last Action
Added `total_revenue() -> float` endpoint to `services/orders.sv.jac`, wired it into `main.jac`, and added a regression test cross-checking revenue by recomputing from `get_order()` details.