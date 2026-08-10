"""Orders page: list user orders + cancel, plus total revenue summary."""

sv import from ..services.orders { list_orders, cancel_order, total_revenue }



def:pub OrdersPage() -> JsxPage {
    has orders: list[dict] = [];
    has loading: bool = True;
    has error: str = "";

    has revenue: float | None = None;
    has revenue_loading: bool = True;
    has revenue_error: str = "";

    async def refresh_orders() -> None {
        try {
            result = await list_orders("user_001");
            orders = result if result else [];
            error = "";
        } except Exception as e {
            error = "Failed to load orders: " + str(e);
            orders = [];
        }
        loading = False;
    }

    async def refresh_revenue() -> None {
        try {
            revenue = await total_revenue();
            revenue_error = "";
        } except Exception as e {
            revenue_error = "Failed to load revenue: " + str(e);
            revenue = None;
        }
        revenue_loading = False;
    }

    async can with entry {
        await refresh_orders();
        await refresh_revenue();
    }

    async def do_cancel(order_id: str) -> None {
        await cancel_order(order_id);
        loading = True;
        await refresh_orders();
        revenue_loading = True;
        await refresh_revenue();
    }

    def fmt_money(amount: float | None) -> str {
        if amount is None {
            return "—";
        }
        return f"${amount:.2f}";
    }

    return <div className="mx-auto max-w-5xl pt-6 pb-6 pl-6 pr-6">
        <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
            <div>
                <h1 className="text-balance text-3xl font-bold tracking-tight sm:text-4xl">Orders</h1>
                <p className="text-sm text-muted-foreground">Review recent orders for the demo user.</p>
            </div>
            <div className="flex items-center gap-2">
                <button
                    className="rounded-md border border-gray-200 bg-white pt-2 pb-2 pl-3 pr-3 text-sm font-medium text-gray-900 hover:bg-gray-50"
                    onClick={lambda { loading = True; revenue_loading = True; refresh_orders(); refresh_revenue(); }}
                >
                    Refresh
                </button>
            </div>
        </div>

        <div className="mt-6 grid grid-cols-1 gap-4 md:grid-cols-2">
            <div className="rounded-xl border bg-white pt-5 pb-5 pl-5 pr-5">
                <div className="text-sm text-gray-600">Total revenue</div>
                <div className="mt-1 text-3xl font-semibold tabular-nums text-gray-900">{fmt_money(revenue)}</div>
                {revenue_loading and <div className="mt-2 text-sm text-gray-500">Loading revenue...</div> or None}
                {revenue_error and <div className="mt-2 text-sm text-red-600">{revenue_error}</div> or None}
            </div>

            <div className="rounded-xl border bg-white pt-5 pb-5 pl-5 pr-5">
                <div className="text-sm text-gray-600">Total orders</div>
                <div className="mt-1 text-3xl font-semibold tabular-nums text-gray-900">{str(len(orders))}</div>
                <div className="mt-2 text-sm text-gray-500">Includes all statuses.</div>
            </div>
        </div>

        <div className="mt-6 rounded-xl border bg-white">
            <div className="border-b pt-5 pb-5 pl-5 pr-5">
                <div className="text-lg font-semibold text-gray-900">Your orders</div>
                <div className="mt-1 text-sm text-gray-500">Cancel pending or processed orders.</div>
            </div>
            <div className="pt-5 pb-5 pl-5 pr-5">
                {if loading {
                    <div className="text-sm text-muted-foreground">Loading...</div>
                    skip;
                }}
                {if error {
                    <div className="text-sm text-destructive">{error}</div>
                    skip;
                }}
                {if len(orders) == 0 {
                    <div className="text-sm text-muted-foreground">No orders yet.</div>
                    skip;
                }}

                <div className="flex flex-col gap-3">
                    {for o in orders {
                        <div key={o["id"]} className="rounded-lg border bg-card pt-4 pb-4 pl-4 pr-4">
                            <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                                <div className="min-w-0">
                                    <div className="font-medium">{o["id"]}</div>
                                    <div className="mt-1 text-xs text-muted-foreground">{o["created_at"]}</div>
                                    <div className="mt-2 text-sm text-muted-foreground">
                                        {(o["shipping_address1"] as str) + ", " + (o["shipping_city"] as str) + ", " + (o["shipping_state"] as str) + " " + (o["shipping_zip"] as str)}
                                    </div>
                                </div>

                                <div className="flex items-center gap-2 sm:flex-col sm:items-end">
                                    <span className="rounded-full bg-gray-100 pt-1 pb-1 pl-2 pr-2 text-xs font-medium text-gray-700">{o["status"]}</span>
                                    {if (o["status"] in ["pending", "processed"]) {
                                        <button
                                            className="rounded-md bg-red-600 pt-2 pb-2 pl-3 pr-3 text-sm font-medium text-white hover:bg-red-700"
                                            onClick={lambda { do_cancel(o["id"] as str); }}
                                        >
                                            Cancel
                                        </button>
                                    }}
                                </div>
                            </div>
                        </div>
                    }}
                </div>
            </div>
        </div>
    </div>;
}
