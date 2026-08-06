## Issues
- [turn 1] Added missing orders.total_revenue endpoint and registered it in main.jac to avoid 405 on new endpoint names.

## Learnings
- New def:pub endpoints must be explicitly imported by name in main.jac for reliable registration.

## Last Action
Implemented services/orders.sv.jac:total_revenue() and added it to main.jac imports.