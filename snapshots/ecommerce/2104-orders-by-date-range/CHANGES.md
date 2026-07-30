# Date Range Filtering for list_orders

## Overview
Extended the `list_orders` endpoint to support date range filtering via optional `from_date` and `to_date` parameters.

## Changes Made

### 1. Updated `list_orders` function signature
**File:** `services/orders.sv.jac` (line 83)

**Before:**
```jac
def:pub list_orders(user_id: str = "") -> list[dict]
```

**After:**
```jac
def:pub list_orders(user_id: str = "", from_date: str = "", to_date: str = "") -> list[dict]
```

### 2. Added filtering logic
The function now filters orders based on the `created_at` field:

- **`from_date`**: When provided, excludes orders where `created_at < from_date` (inclusive lower bound)
- **`to_date`**: When provided, excludes orders where `created_at > to_date` (inclusive upper bound)
- **Both empty**: Returns all orders (preserves original behavior)

The filters are applied sequentially and can be combined with the existing `user_id` filter.

### 3. Implementation details
```jac
if from_date {
    orders = [o for o in orders if o.created_at >= from_date];
}
if to_date {
    orders = [o for o in orders if o.created_at <= to_date];
}
```

## Usage Examples

### 1. Get all orders (unchanged behavior)
```jac
orders = list_orders("");
```

### 2. Filter by from_date only
```jac
# Get orders from February 1st, 2024 onwards
orders = list_orders("", from_date="2024-02-01T00:00:00");
```

### 3. Filter by to_date only
```jac
# Get orders up to January 18th, 2024
orders = list_orders("", to_date="2024-01-18T23:59:59");
```

### 4. Filter by date range
```jac
# Get orders between January 16-19, 2024
orders = list_orders("", from_date="2024-01-16T00:00:00", to_date="2024-01-19T23:59:59");
```

### 5. Combine user and date filters
```jac
# Get alice's orders from January 16th onwards
orders = list_orders("user_001", from_date="2024-01-16T00:00:00");
```

## Date Format
- Both parameters expect ISO 8601 timestamp strings
- Format: `"YYYY-MM-DDTHH:MM:SS"` (e.g., `"2024-01-16T00:00:00"`)
- This matches the format already used in the `created_at` field of orders

## Backward Compatibility
✅ Fully backward compatible - existing code that calls `list_orders()` or `list_orders(user_id)` will continue to work exactly as before, since both new parameters are optional and default to empty strings.

## Testing
Added comprehensive tests in `tests/baseline.jac`:
- ✅ Filter by from_date (inclusive)
- ✅ Filter by to_date (inclusive)
- ✅ Filter by both from_date and to_date
- ✅ Combine user_id and date filters
