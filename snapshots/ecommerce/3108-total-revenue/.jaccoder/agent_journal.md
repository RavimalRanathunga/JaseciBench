## Issues
- [turn 1] main.jac used `to cl:` which caused a syntax error; fixed by using an explicit `cl { ... }` block for the client section.
- [turn 1] Type error in orders.sv.jac from string concatenation with a non-str value; fixed by wrapping with str().

## Learnings
- New server endpoints must be added to main.jac imports to be registered reliably (avoids 405s).

## Last Action
Implemented `total_revenue() -> float` in services/orders.sv.jac and imported it in main.jac; updated agent journal.