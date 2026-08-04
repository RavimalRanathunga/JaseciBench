"""Orders page: list user's orders."""

sv import from ..services.orders { list_orders, cancel_order }


def:pub OrdersPage() -> JsxPage {
    has orders: list[dict] = [];
    has loading: bool = True;
    has error: str = "";

    async can with entry {
        try {
            resp = await list_orders("user_001");
            orders = resp if resp else [];
        } except Exception {
            error = "Failed to load orders.";
            orders = [];
        }
        loading = False;
    }

    async def do_cancel(order_id: str) -> None {
        await cancel_order(order_id);
        resp = await list_orders("user_001");
        orders = resp if resp else [];
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Orders</h1>

        {if loading {
            <p className="text-gray-500">Loading...</p>
        } elif error {
            <p className="text-red-600">{error}</p>
        } elif len(orders) == 0 {
            <p className="text-gray-600">No orders yet.</p>
        } else {
            <div className="space-y-4">
                {for o in orders {
                    <div key={o["id"] as str} className="bg-white rounded-2xl border border-gray-200 p-5 flex items-start justify-between gap-6">
                        <div>
                            <div className="text-sm font-semibold text-gray-900">{"Order " + str(o["id"])}</div>
                            <div className="text-xs text-gray-500 mt-1">{"Total: $" + str(o["total"])}</div>
                        </div>

                        <div className="flex flex-col items-end gap-2">
                            <span className="text-xs text-gray-600">{str(o["status"])}</span>
                            {if str(o["status"]) in ["pending", "processed"] {
                                <button
                                    type="button"
                                    onClick={lambda (e: MouseEvent) { do_cancel(o["id"] as str); }}
                                    className="text-xs text-red-600 hover:text-red-700 hover:underline"
                                >Cancel</button>
                            }}
                        </div>
                    </div>
                }}
            </div>
        }}
    </div>;
}
