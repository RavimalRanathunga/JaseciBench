"""Search page: search products by query."""

sv import from ..services.catalog { search_products, search_suggestions }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;

    has suggestions: list[str] = [];
    has sug_loading: bool = True;
    has sug_error: str = "";

    async can with entry {
        sug_loading = True;
        sug_error = "";
        try {
            res = await search_suggestions();
            suggestions = res if res else [];
        } except Exception {
            sug_error = "Failed to load suggestions.";
            suggestions = [];
        }
        sug_loading = False;
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

    def select_suggestion(s: str) -> None {
        query = s;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <form onSubmit={do_search} className="flex gap-2 mb-3">
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

        <div className="flex flex-wrap items-center gap-2 mb-6">
            <span className="text-sm text-gray-600">Try:</span>
            {if sug_loading {
                <span className="text-sm text-gray-500">Loading...</span>
            } else {
                if sug_error {
                    <span className="text-sm text-red-600">{sug_error}</span>
                } else {
                    for s in suggestions {
                        <button
                            key={s}
                            type="button"
                            onClick={lambda (_e: MouseEvent) { select_suggestion(s); }}
                            className="px-3 py-1.5 rounded-full border border-gray-200 bg-white hover:bg-gray-50 text-sm text-gray-900"
                        >
                            {s}
                        </button>
                    }
                }
            }}
        </div>

        {if searching {
            <p className="text-gray-500">Searching...</p>
        }}

        {if len(results) > 0 {
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                {[<ProductCard key={p["id"]} product={p} /> for p in results]}
            </div>
        } else {
            if searched and not searching {
                <p className="text-gray-500">No results.</p>
            }
        }}
    </div>;
}
