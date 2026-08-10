"""Top-level client shell: Router + Routes."""

import from "@jac/runtime" { Router, Routes, Route, Navigate }
import from .components.Header { Header }


def:pub Shell() -> JsxElement {
    return <Router>
        <div className="min-h-screen bg-gray-50">
            <Header />
            <div className="max-w-5xl mx-auto px-6 py-10">
                <div className="bg-white border border-gray-200 rounded-2xl p-6">
                    <h1 className="text-2xl font-bold text-gray-900">Jac E-Commerce</h1>
                    <p className="text-gray-600 mt-2">App shell is running.</p>
                    <p className="text-gray-600 mt-1">Backend analytics endpoint: <code className="px-1 py-0.5 bg-gray-100 rounded">user_with_most_orders()</code>.</p>
                </div>
            </div>
            <Routes>
                <Route path="/" element={<div />} />
                <Route path="*" element={<Navigate to="/" replace={True} />} />
            </Routes>
        </div>
    </Router>;
}
