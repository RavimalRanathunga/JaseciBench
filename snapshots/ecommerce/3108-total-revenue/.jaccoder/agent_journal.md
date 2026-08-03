## Issues
- [turn 1] Added missing orders.total_revenue() endpoint.

## Learnings
- total_revenue definition belongs in services/orders.sv.jac and must be imported in main.jac to be reachable by REST/RPC.

## Last Action
Implemented total_revenue() and wired it into main.jac server imports; pending: run checks/tests and start server to validate endpoint output.