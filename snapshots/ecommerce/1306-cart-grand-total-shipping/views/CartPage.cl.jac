"""Cart page: view + mutate cart, checkout."""

import from "@jac/runtime" { Link, useNavigate }
sv import from ..services.cart { get_cart, update_cart_item, remove_from_cart, checkout }


def:pub CartPage() -> JsxElement {
    has cart: Any = None;
    has loading: bool = True;
    has checking_out: bool = False;
    has feedback: str = "";

    nav = useNavigate();

    async def refresh() -> None {
        result = await get_cart("user_001");
        cart = result if result else {"items": [], "total": 0.0, "shipping": 0.0, "grand_total": 0.0};
        loading = False;
    }

    async can with entry {
        await refresh();
    }

    async def update_qty(item_id: str, qty: int) -> None {
        await update_cart_item(item_id, qty);
        await refresh();
    }

    async def remove_item(item_id: str) -> None {
        await remove_from_cart(item_id);
        await refresh();
    }

    async def do_checkout(_e: MouseEvent) -> None {
        checking_out = True;
        result = await checkout("user_001", "pm_001", "123 Main St", "New York", "NY", "10001");
        checking_out = False;
        if result and "error" in result {
            feedback = "Error: " + str(result["error"]);
        } else {
            nav("/orders");
        }
    }

    if loading {
        return <div className="max-w-4xl mx-auto px-6 py-12 text-gray-500">Loading...</div>;
    }

    items: list = (cart["items"] if cart else []) as list;

    return <div className="max-w-4xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Shopping Cart</h1>

        {(<div>
            <div className="space-y-3">
                {for item in items {
                    item_id = item["id"] as str;
                    item_color = item["color"] as str;
                    item_size = item["size"] as str;
                    item_price = item["price"] as float;
                    item_qty = item["quantity"] as int;

                    <div key={item_id} className="flex items-center gap-4 p-4 bg-white border border-gray-200 rounded-xl">
                        <div className="w-16 h-16 bg-gradient-to-br from-gray-100 to-gray-50 rounded-lg flex items-center justify-center text-gray-300 text-xl font-light">
                            {item_color[0:1] if item_color else "?"}
                        </div>
                        <div className="flex-1 min-w-0">
                            <div className="text-sm font-semibold text-gray-900">
                                {item_color + " · " + item_size}
                            </div>
                            <div className="text-xs text-gray-500 mt-0.5">
                                {"$" + str(item_price) + " each"}
                            </div>
                        </div>
                        <div className="flex items-center gap-2">
                            <button
                                onClick={lambda (_e: MouseEvent) { update_qty(item_id, item_qty - 1); }}
                                className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 text-gray-600"
                            >−</button>
                            <span className="w-8 text-center text-sm font-medium">{item_qty}</span>
                            <button
                                onClick={lambda (_e: MouseEvent) { update_qty(item_id, item_qty + 1); }}
                                className="w-8 h-8 rounded border border-gray-300 hover:bg-gray-50 text-gray-600"
                            >+</button>
                        </div>
                        <button
                            onClick={lambda (_e: MouseEvent) { remove_item(item_id); }}
                            className="text-gray-400 hover:text-red-600 text-sm"
                        >Remove</button>
                    </div>;
                }}
            </div>

            <div className="mt-6 p-5 bg-gray-50 rounded-xl">
                <div className="space-y-2 mb-4">
                    <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Subtotal</span>
                        <span className="text-gray-900 font-medium">{"$" + str(cart["total"])}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Shipping</span>
                        <span className="text-gray-900 font-medium">{"$" + str(cart["shipping"])}</span>
                    </div>
                    <div className="flex justify-between pt-2 border-t border-gray-200">
                        <span className="text-base font-semibold text-gray-900">Grand Total</span>
                        <span className="text-2xl font-bold text-gray-900">{"$" + str(cart["grand_total"])}</span>
                    </div>
                </div>
                <button
                    onClick={do_checkout}
                    disabled={checking_out}
                    className="w-full px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors disabled:opacity-50"
                >
                    {("Processing..." if checking_out else "Checkout")}
                </button>
            </div>
            {(<p className="mt-3 text-sm text-center text-red-600">{feedback}</p>) if feedback else None}
        </div>) if len(items) > 0 else None}
    </div>;
}
