"""Search page: search products by query."""

sv import from ..services.catalog { search_products, trending_searches }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;

    has trends_loading: bool = True;
    has trends_error: str = "";
    has trends: list[str] = [];

    useEffect(lambda {
        async def load_trends() -> None {
            trends_loading = True;
            trends_error = "";
            resp = await trending_searches();
            trends = resp if resp else [];
            trends_loading = False;
        }

        load_trends();
    }, []);

    async def do_search(e: FormEvent) -> None {
        e.preventDefault();
        if not query.strip() { return; }
        searching = True;
        result = await search_products(query);
        results = result if result else [];
        searching = False;
        searched = True;
    }

    def set_query_and_search(term: str) -> None {
        query = term;
        # keep it simple: user can hit Search after clicking a term
        searched = False;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <div className="mb-6">
            <div className="text-sm font-semibold text-gray-700 mb-2">Trending:</div>
            {(<p className="text-gray-500 text-sm">Loading...</p>) if trends_loading else None}
            {(<p className="text-red-600 text-sm">{trends_error}</p>) if (not trends_loading and trends_error) else None}
            {(<div className="flex flex-wrap gap-2">
                {[<button
                    key={t}
                    type="button"
                    onClick={lambda (e: MouseEvent) { set_query_and_search(t); }}
                    className="px-3 py-1.5 rounded-full border border-gray-300 text-gray-700 text-sm hover:bg-gray-50"
                >
                    {t}
                </button> for t in trends]}
            </div>) if (not trends_loading and not trends_error and len(trends) > 0) else None}
            {(<p className="text-gray-500 text-sm">No trending searches.</p>) if (not trends_loading and not trends_error and len(trends) == 0) else None}
        </div>

        <form onSubmit={do_search} className="flex gap-2 mb-8">
            <input
                type="text"
                value={query}
                onChange={lambda (e: ChangeEvent) { query = e.target.value; }}
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
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in results]}
        </div>) if len(results) > 0 else None}
        {(<p className="text-gray-500">No results.</p>) if (searched and not searching and len(results) == 0) else None}
    </div>;
}
