"""E-commerce app entry point.

Server endpoints (def:pub) are registered here; the f"cl" block below mounts
the f"Shell" component client-side. Seeding happens lazily on first endpoint
call (services.catalog.ensure_seeded).
"""

import from seed { seed_catalog }
import from services.catalog {
    list_categories,
    list_products,
    get_product,
    search_products,
    search_suggestions,
}
import from services.users {
    list_users,
    get_profile,
    list_addresses,
    list_payment_methods,
    add_address,
    update_address,
    delete_address,
}
import from services.reviews { list_reviews, add_review, product_review_summary }
import from services.cart {
    get_cart,
    add_to_cart,
    update_cart_item,
    remove_from_cart,
    clear_cart,
    checkout,
}
import from services.orders {
    list_orders,
    get_order,
    cancel_order,
    update_order_status,
    return_items,
    modify_order_items,
    update_order_address,
}


cl import "./global.css";

cl {
    import from "@jac/runtime" { Router, Routes, Route, Navigate }

    import from .pages.CatalogPage { CatalogPage }
    import from .pages.ProductPage { ProductPage }
    import from .pages.CartPage { CartPage }
    import from .pages.OrdersPage { OrdersPage }
    import from .pages.SearchPage { SearchPage }

    import from .frontend { Shell }

    def:pub app() -> JsxElement {
        return <Router>
            <Shell>
                <Routes>
                    <Route path="/" element={<Navigate to="/catalog" replace={True} />} />
                    <Route path="/catalog" element={<CatalogPage />} />
                    <Route path="/product/:id" element={<ProductPage />} />
                    <Route path="/cart" element={<CartPage />} />
                    <Route path="/orders" element={<OrdersPage />} />
                    <Route path="/search" element={<SearchPage />} />
                </Routes>
            </Shell>
        </Router>;
    }
}
