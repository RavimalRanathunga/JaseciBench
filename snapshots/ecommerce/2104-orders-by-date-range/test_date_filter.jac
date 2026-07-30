"""
Quick test to verify the date range filtering on list_orders
"""

import from services.orders { list_orders }


test "list_orders with no dates returns all orders" {
    orders = list_orders("");
    all_count = len(orders);
    assert all_count > 0;
    print(f"Total orders: {all_count}");
}


test "list_orders filters by from_date" {
    # Get orders from Feb 1st onwards
    orders = list_orders("", from_date="2024-02-01T00:00:00");
    print(f"Orders from 2024-02-01: {len(orders)}");
    for o in orders {
        print(f"  Order {o['id']}: {o['created_at']}");
        assert o["created_at"] >= "2024-02-01T00:00:00";
    }
}


test "list_orders filters by to_date" {
    # Get orders up to Jan 18th
    orders = list_orders("", to_date="2024-01-18T23:59:59");
    print(f"Orders up to 2024-01-18: {len(orders)}");
    for o in orders {
        print(f"  Order {o['id']}: {o['created_at']}");
        assert o["created_at"] <= "2024-01-18T23:59:59";
    }
}


test "list_orders filters by date range" {
    # Get orders between Jan 16 and Jan 19
    orders = list_orders("", from_date="2024-01-16T00:00:00", to_date="2024-01-19T23:59:59");
    print(f"Orders between 2024-01-16 and 2024-01-19: {len(orders)}");
    for o in orders {
        print(f"  Order {o['id']}: {o['created_at']}");
        assert o["created_at"] >= "2024-01-16T00:00:00";
        assert o["created_at"] <= "2024-01-19T23:59:59";
    }
}


test "list_orders combines user and date filters" {
    # Get alice's orders from Jan 16 onwards
    orders = list_orders("user_001", from_date="2024-01-16T00:00:00");
    print(f"Alice's orders from 2024-01-16: {len(orders)}");
    for o in orders {
        print(f"  Order {o['id']}: {o['created_at']}, user: {o['user_id']}");
        assert o["user_id"] == "user_001";
        assert o["created_at"] >= "2024-01-16T00:00:00";
    }
}
