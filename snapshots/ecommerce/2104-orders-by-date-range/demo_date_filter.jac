"""
Demonstration script to verify date range filtering on list_orders
"""

with entry {
    import from services.orders { list_orders }
    
    print("\n== Testing list_orders date range filtering ==\n");
    
    print("1. All orders (no filters):");
    all_orders = list_orders("");
    print(f"   Total: {len(all_orders)} orders");
    for o in all_orders {
        print(f"   - {o['id']}: {o['created_at']} (user: {o['user_id']})");
    }
    
    print("\n2. Orders from 2024-02-01 onwards (from_date filter):");
    feb_orders = list_orders("", from_date="2024-02-01T00:00:00");
    print(f"   Total: {len(feb_orders)} orders");
    for o in feb_orders {
        print(f"   - {o['id']}: {o['created_at']}");
        assert o["created_at"] >= "2024-02-01T00:00:00";
    }
    
    print("\n3. Orders up to 2024-01-18 (to_date filter):");
    jan_orders = list_orders("", to_date="2024-01-18T23:59:59");
    print(f"   Total: {len(jan_orders)} orders");
    for o in jan_orders {
        print(f"   - {o['id']}: {o['created_at']}");
        assert o["created_at"] <= "2024-01-18T23:59:59";
    }
    
    print("\n4. Orders between 2024-01-16 and 2024-01-19 (date range):");
    range_orders = list_orders("", from_date="2024-01-16T00:00:00", to_date="2024-01-19T23:59:59");
    print(f"   Total: {len(range_orders)} orders");
    for o in range_orders {
        print(f"   - {o['id']}: {o['created_at']}");
        assert o["created_at"] >= "2024-01-16T00:00:00";
        assert o["created_at"] <= "2024-01-19T23:59:59";
    }
    
    print("\n5. Alice's orders from 2024-01-16 onwards (user + date filter):");
    alice_orders = list_orders("user_001", from_date="2024-01-16T00:00:00");
    print(f"   Total: {len(alice_orders)} orders");
    for o in alice_orders {
        print(f"   - {o['id']}: {o['created_at']} (user: {o['user_id']})");
        assert o["user_id"] == "user_001";
        assert o["created_at"] >= "2024-01-16T00:00:00";
    }
    
    print("\n✓ All date range filtering tests passed!\n");
}
