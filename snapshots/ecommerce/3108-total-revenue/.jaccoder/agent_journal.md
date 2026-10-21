## Issues
- None.

## Learnings
- Orders and their payments are connected directly in the graph; the revenue endpoint traverses every Order and sums Payment amounts by transaction type.
- Public endpoint registration requires importing the endpoint from `main.jac`.

## Last Action
- Added `total_revenue() -> float` in `services/orders.sv.jac` and registered it in `main.jac`.
- `jac check main.jac` passed; all 32 baseline tests passed.