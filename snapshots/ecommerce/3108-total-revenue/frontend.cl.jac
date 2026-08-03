"""Top-level client shell: Router + Routes."""

import from "@jac/runtime" { Router, Routes, Route, Navigate }
import from .components.Header { Header }


def:pub Shell() -> JsxElement {
    return <Router>
        <div className="min-h-screen bg-gray-50">
            <Header />
            <div className="max-w-6xl mx-auto px-6 py-12">
                <h1 className="text-3xl font-bold text-gray-900">Jac E-Commerce</h1>
                <p className="text-gray-600 mt-2">
                    App is running. Routes are temporarily disabled while the pages module is being repaired.
                </p>
            </div>
            <Routes>
                <Route path="*" element={<Navigate to="/" replace={True} />} />
            </Routes>
        </div>
    </Router>;
}
