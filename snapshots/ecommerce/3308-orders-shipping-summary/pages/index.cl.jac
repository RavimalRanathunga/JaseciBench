"""Catalog index route (/)"""

import from .CatalogPage { CatalogPage }


def:pub Index() -> JsxPage {
    return <CatalogPage />;
}
