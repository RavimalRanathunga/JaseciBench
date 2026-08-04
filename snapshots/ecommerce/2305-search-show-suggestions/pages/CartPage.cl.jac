"""Cart page: view and manage cart items."""

sv import from ..services.cart { get_cart, update_cart_item, remove_from_cart, checkout }
import from "@jac/runtime" { Link }


def:pub CartPage() -> JsxPage {
    has cart: dict | None = None;
    has loading: bool = True;
    has error: str = "";

    async can with entry {
        try {
            cart = await get_cart("user_001");
        } except Exception {
            error = "Failed to load cart.";
        }
        loading = False;
    }

    async def refresh() -> None {
        cart = await get_cart("user_001");
    }

    async def update_qty(item_id: str, qty: int) -> None {
        await update_cart_item(item_id, qty);
        await refresh();
    }

    async def remove_item(item_id: str) -> None {
        await remove_from_cart(item_id);
        await refresh();
    }

    async def do_checkout(e: MouseEvent) -> None {
        e.preventDefault();
        if not cart {
            return;
        }
        # Pick a valid payment method id and shipping fields from user profile in a follow-up.
        await checkout("user_001", "pm_001", "123 Main St", "Town", "CA", "12345");
        await refresh();
    }

    if loading {
        return <div className="max-w-6xl mx-auto px-6 py-8 text-gray-500">Loading...</div>;
    }

    if error {
        return <div className="max-w-6xl mx-auto px-6 py-8">
            <p className="text-red-600">{error}</p>
            <Link to="/" className="text-indigo-600 hover:underline mt-4 inline-block">Back to catalog</Link>
        </div>;
    }

    items: list[dict] = (cart["items"] as list[dict]) if cart else [];

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Your Cart</h1>

        {if len(items) == 0 {
            <div className="bg-white rounded-2xl border border-gray-200 p-8 text-center">
                <p className="text-gray-600">Your cart is empty.</p>
                <Link to="/" className="mt-4 inline-block text-indigo-600 hover:underline">Browse products</Link>
            </div>
        } else {
            <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
                <div className="divide-y divide-gray-200">
                    {for item in items {
                        <div key={item["id"] as str} className="p-5 flex items-center gap-4">
                            <div className="flex-1 min-w-0">
                                <div className="text-sm font-semibold text-gray-900">{item["name"]}</div>
                                <div className="text-xs text-gray-500 mt-0.5">{"$" + str(item["price"]) + " each"}</div>
                            </div>

                            <div className="flex items-center gap-2">
                                <button
                                    type="button"
                                    onClick={lambda (e: MouseEvent) { update_qty(item["id"] as str, (item["quantity"] as int) - 1); }}
                                    className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 text-gray-600"
                                >−</button>
                                <span className="w-8 text-center text-sm font-medium">{item["quantity"]}</span>
                                <button
                                    type="button"
                                    onClick={lambda (e: MouseEvent) { update_qty(item["id"] as str, (item["quantity"] as int) + 1); }}
                                    className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 text-gray-600"
                                >+</button>
                            </div>

                            <button
                                type="button"
                                onClick={lambda (e: MouseEvent) { remove_item(item["id"] as str); }}
                                className="text-gray-400 hover:text-red-600 text-sm"
                            >Remove</button>
                        </div>
                    }}
                </div>

                <div className="p-5 bg-gray-50 flex items-center justify-between">
                    <span className="text-sm text-gray-700">Subtotal</span>
                    <span className="text-sm font-semibold text-gray-900">{"$" + str(cart?["total"] or 0)}</span>
                </div>
            </div>

            <button
                onClick={do_checkout}
                className="mt-6 w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors"
            >
                Checkout
            </button>
        }}
    </div>;
}
