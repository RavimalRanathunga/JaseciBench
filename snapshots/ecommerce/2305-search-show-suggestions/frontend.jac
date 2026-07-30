"""Top-level client shell: Router + Routes."""

import from "@jac/runtime" { Router, Routes, Route, Navigate }
import from .components.Header { Header }
import from .components.SearchPage { SearchPage }

# Minimal routes while pages/ routing is disabled.
def:pub _Placeholder(title: str) -> JsxElement {
    <div className="max-w-4xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900">{title}</h1>
        <p className="text-gray-600 mt-2">This page is not available in this snapshot.</p>
        <a href="/search" className="text-indigo-600 hover:underline">Go to search</a>
    </div>
}



def:pub Shell() -> JsxElement {
    return <Router>
        <div className="min-h-screen bg-gray-50">
            <Header />
            <Routes>
                <Route path="/" element={<_Placeholder title="Catalog" />} />
                <Route path="/products/:id" element={<_Placeholder title="Product" />} />
                <Route path="/cart" element={<_Placeholder title="Cart" />} />
                <Route path="/orders" element={<_Placeholder title="Orders" />} />
                <Route path="/search" element={<SearchPage />} />
                <Route path="*" element={<Navigate to="/" replace={True} />} />
            </Routes>
        </div>
    </Router>;
}
