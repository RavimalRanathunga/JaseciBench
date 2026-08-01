"""Search page: search products by query."""

sv import from ..services.catalog { search_products, trending_searches }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;
    has trending: list[str] = [];

    async can with entry {
        res = await trending_searches();
        trending = res if res else [];
    }

    async def do_search(e: FormEvent) -> None {
        e.preventDefault();
        if not query.strip() {
            return;
        }
        searching = True;
        result = await search_products(query);
        results = result if result else [];
        searching = False;
        searched = True;
    }

    def on_query_change(e: ChangeEvent) {
        query = e.target.value;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Search Products</h1>

        <div className="text-sm text-gray-600 mb-6">
            <span className="font-medium">Trending:</span>
            <span className="ml-2">
                {if len(trending) == 0 {
                    <span className="text-gray-400">Loading...</span>
                } else {
                    for t in trending {
                        <button
                            key={t}
                            type="button"
                            className="inline-flex items-center px-2 py-0.5 mr-2 mb-2 rounded-md border border-gray-200 bg-white hover:bg-gray-50 text-gray-700"
                            onClick={lambda { query = t; }}
                        >
                            {t}
                        </button>
                    }
                }}
            </span>
        </div>

        <form onSubmit={do_search} className="flex gap-2 mb-8">
            <input
                type="text"
                value={query}
                onChange={on_query_change}
                placeholder="Try 'shirt', 'coffee', 'wireless'..."
                className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
            />
            <button
                type="submit"
                className="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg"
            >
                Search
            </button>
        </form>

        {(<p className="text-gray-500">Searching...</p>) if searching else None}
        {(<p className="text-gray-500">No results.</p>) if (searched and (not searching) and len(results) == 0) else None}
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in results]}
        </div>) if len(results) > 0 else None}
    </div>;
}
