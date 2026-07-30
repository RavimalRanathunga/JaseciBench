## Issues
- [turn 1] N/A

## Learnings
- ISO timestamps in this app are stored as strings in Order.created_at; lexicographic compare works for the existing format.

## Last Action
Extend services.orders.list_orders to accept optional from_date/to_date filters (inclusive) while preserving existing response shape.