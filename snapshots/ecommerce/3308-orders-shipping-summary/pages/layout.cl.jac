"""Root layout for file-based routing."""

import from "@jac/runtime" { Outlet }
import from ..components.Header { Header }


def:pub RootLayout() -> JsxLayout {
    return <div className="min-h-screen bg-gray-50">
        <Header />
        <Outlet />
    </div>;
}
