"""Top-level client shell: Router + Routes."""

import from "@jac/runtime" { Router, Routes, Route, Navigate }
import from .components.Header { Header }
import from .views.CatalogPage { CatalogPage }
import from .views.ProductPage { ProductPage }
import from .views.CartPage { CartPage }
import from .views.OrdersPage { OrdersPage }
import from .views.SearchPage { SearchPage }


def:pub Shell() -> JsxElement {
    return <Router>
        <div className="min-h-screen bg-gray-50">
            <Header />
            <Routes>
                <Route path="/" element={<CatalogPage />} />
                <Route path="/products/:id" element={<ProductPage />} />
                <Route path="/cart" element={<CartPage />} />
                <Route path="/orders" element={<OrdersPage />} />
                <Route path="/search" element={<SearchPage />} />
                <Route path="*" element={<Navigate to="/" replace={True} />} />
            </Routes>
        </div>
    </Router>;
}
