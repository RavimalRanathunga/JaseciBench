"""Orders route (/orders)"""

import from .OrdersPage { OrdersPage }


def:pub OrdersRoute() -> JsxPage {
    return <OrdersPage />;
}
