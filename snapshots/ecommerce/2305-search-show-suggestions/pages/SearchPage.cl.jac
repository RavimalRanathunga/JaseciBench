
sv import from ..services.catalog { search_products, search_suggestions }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;
    has suggestions: list[str] = [];
    has suggestions_loading: bool = True;
    has suggestions_error: bool = False;

    async can with entry {
        try {
            suggestions = await search_suggestions();
        } except Exception {
            suggestions_error = True;
        }
        suggestions_loading = False;
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

        <div className="mb-8 flex flex-wrap items-center gap-2">
            <span className="text-sm text-gray-600">Try:</span>
            {if suggestions_loading {
                <span className="text-sm text-gray-500">Loading suggestions...</span>
            } else if suggestions_error {
                <span className="text-sm text-red-600">Could not load suggestions.</span>
            } else {
                {for suggestion in suggestions {
                    <button
                        key={suggestion}
                        type="button"
                        onClick={lambda (e: MouseEvent) { query = suggestion; }}
                        className="rounded-full border border-gray-300 bg-white px-3 py-1.5 text-sm text-gray-700 transition-colors hover:border-indigo-600 hover:text-indigo-600"
                    >
                        {suggestion}
                    </button>
                }}
            }}
        </div>

        {(<p className="text-gray-500">Searching...</p>) if searching else None}
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in results]}
        </div>) if len(results) > 0 else None}
        {(<p className="text-gray-500">No products found. Try another search.</p>) if searched and len(results) == 0 and not searching else None}
    </div>;
}
