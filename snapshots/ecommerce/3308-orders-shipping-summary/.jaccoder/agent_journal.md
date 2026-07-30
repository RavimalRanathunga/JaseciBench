## Issues
- [turn 1] orders.sv.jac type error from string concatenation with non-str `oi_id`; fixed by wrapping with `str(oi_id)`.

## Learnings
- Adding derived fields to API dicts is easiest by computing once (e.g., `shipping_summary`) and inserting into both include_items branches.

## Last Action
Added `shipping_summary` to `order_dict` and updated OrdersPage to render it.