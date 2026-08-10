## Issues
- [turn 1] `add_review` accepted out-of-range ratings; fixed by adding an early bounds check returning `{error, status: 400}`.

## Learnings
- `jac check` requires explicit paths (e.g. `jac check .`).

## Last Action
Added rating validation (1–5) to `services/reviews.sv.jac:add_review` while preserving existing 404 product-not-found behavior.