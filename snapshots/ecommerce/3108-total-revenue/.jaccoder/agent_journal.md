## Issues
- None.

## Learnings
- Public endpoints added to an existing service module must also be named in the entry module import for registration.
- Payment nodes are attached to individual orders; aggregate by traversing every order’s Payment relationships.

## Last Action
Added `total_revenue() -> float` to `services/orders.sv.jac`, summing payment amounts and subtracting refund amounts after lazy seeding. Registered it in `main.jac`. `jac check main.jac` passes (existing W3005 warning only).
