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
        trending = await trending_searches();
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

    def click_trending(term: str) {
        query = term;
    }

    def handle_change(e: ChangeEvent) {
        query = e.target.value;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <form onSubmit={do_search} className="flex gap-2 mb-4">
            <input
                type="text"
                value={query}
                onChange={handle_change}
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

        {if len(trending) > 0 {
            <div className="mb-8">
                <span className="text-sm text-gray-600 mr-2">Trending:</span>
                {for (i, term) in enumerate(trending) {
                    <button
                        key={str(i)}
                        onClick={lambda { click_trending(term); }}
                        className="text-sm px-3 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-full mr-2"
                    >
                        {term}
                    </button>
                }}
            </div>
        }}

        {(<p className="text-gray-500">Searching...</p>) if searching else None}
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in results]}
        </div>) if len(results) > 0 else None}
    </div>;
}
