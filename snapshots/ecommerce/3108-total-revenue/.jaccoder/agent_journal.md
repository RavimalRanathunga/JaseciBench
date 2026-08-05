## Issues
- [turn 1] main.jac failed to parse due to legacy `to cl:`; fixed by wrapping client section in `cl { ... }`.
- [turn 1] orders service type error when concatenating string with non-str id; fixed with `str(oi_id)`.

## Learnings
- Fullstack entry supports explicit `cl { ... }` for client code; `to cl:` is not valid in this project setup.
- New `def:pub` endpoints must be imported in `main.jac` to register reliably.

## Last Action
Added `total_revenue() -> float` endpoint in `services/orders.sv.jac` and registered it via `main.jac` import; updated baseline test imports.