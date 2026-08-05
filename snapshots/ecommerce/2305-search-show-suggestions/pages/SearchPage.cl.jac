"""Search page: search products by query."""

sv import from ..services.catalog { search_products, search_suggestions }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;
    has suggestions: list[str] = [];

    async can with entry {
        res = await search_suggestions();
        suggestions = res if res else [];
    }

    async def do_search(e: FormEvent) -> None {
        e.preventDefault();
        if not query.strip() { return; }
        searching = True;
        result = await search_products(query);
        results = result if result else [];
        searching = False;
        searched = True;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <form onSubmit={do_search} className="flex gap-2 mb-3">
            <input
                type="text"
                value={query}
                onChange={lambda (e: ChangeEvent) { query = e.target.value; }}
                placeholder="Search products"
                className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
            />
            <button
                type="submit"
                className="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg"
            >
                Search
            </button>
        </form>

        {(<div className="flex flex-wrap items-center gap-2 mb-6">
            <span className="text-sm text-gray-600">Try:</span>
            {[<button
                key={s}
                type="button"
                onClick={lambda (_e: MouseEvent) { query = s; }}
                className="px-3 py-1.5 text-sm rounded-full border border-gray-300 bg-white hover:bg-gray-50 text-gray-800"
            >
                {s}
            </button> for s in suggestions]}
        </div>) if len(suggestions) > 0 else None}

        {(<p className="text-gray-500">Searching...</p>) if searching else None}
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in results]}
        </div>) if len(results) > 0 else None}
        {(<p className="text-gray-500">No results found.</p>) if (searched and not searching and len(results) == 0) else None}
    </div>;
}
