"""E-commerce app entry point."""

# Server endpoints are discovered via imports.
import from seed { seed_catalog }
import from services.catalog { list_categories, list_products, get_product, search_products }
import from services.users {
    list_users, get_profile, list_addresses, list_payment_methods,
    add_address, update_address, delete_address,
}
import from services.reviews { list_reviews, add_review, product_review_summary }
import from services.cart { get_cart, add_to_cart, update_cart_item, remove_from_cart, clear_cart, checkout }
import from services.orders {
    list_orders, get_order, cancel_order, update_order_status,
    return_items, modify_order_items, update_order_address,
}

cl import "./global.css";

cl import from "@jac/runtime" { Router, Routes, Route, Navigate }

cl import from pages.index { HomePage }
cl import from pages.catalog { CatalogPage }
cl import from pages.product { ProductPage }
cl import from pages.search { SearchPage }
cl import from pages.cart { CartPage }
cl import from pages.orders { OrdersPage }


def:pub app() -> JsxElement {
    return <Router>
        <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/catalog" element={<CatalogPage />} />
            <Route path="/product/:id" element={<ProductPage />} />
            <Route path="/search" element={<SearchPage />} />
            <Route path="/cart" element={<CartPage />} />
            <Route path="/orders" element={<OrdersPage />} />
            <Route path="*" element={<Navigate to="/" replace={True} />} />
        </Routes>
    </Router>;
}
