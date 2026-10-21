## Issues
- None.

## Learnings
- Public service endpoints must also be imported by `main.jac` to register.

## Last Action
- Added and registered `user_with_most_orders()` in `services/orders.sv.jac`; added a maximum-count regression test. `jac check main.jac` and all 33 baseline tests pass.