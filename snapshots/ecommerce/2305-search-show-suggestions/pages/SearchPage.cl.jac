"""Search page: search products by query."""

sv import from ..services.catalog { search_products, search_suggestions }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxPage {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;

    has suggestions: list[str] = [];
    has loading_suggestions: bool = True;
    has suggestions_error: str = "";

    async can with entry {
        loading_suggestions = True;
        suggestions_error = "";
        try {
            resp = await search_suggestions();
            suggestions = resp if resp else [];
        } except Exception {
            suggestions_error = "Failed to load suggestions.";
            suggestions = [];
        }
        loading_suggestions = False;
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

    def handle_query_change(e: ChangeEvent) -> None {
        query = e.target.value;
    }

    def apply_suggestion(s: str) -> None {
        query = s;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <form onSubmit={do_search} className="flex gap-2 mb-4">
            <input
                type="text"
                value={query}
                onChange={handle_query_change}
                placeholder="Search products..."
                className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
            />
            <button
                type="submit"
                className="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg"
            >
                Search
            </button>
        </form>

        <div className="mb-8">
            <div className="text-sm text-gray-600 mb-2">Try:</div>

            {if loading_suggestions {
                <div className="text-sm text-gray-500">Loading suggestions...</div>
            } else {
                if suggestions_error {
                    <div className="text-sm text-red-600">{suggestions_error}</div>
                } else {
                    <div className="flex flex-wrap gap-2">
                        {for s in suggestions {
                            <button
                                key={s}
                                type="button"
                                onClick={lambda { apply_suggestion(s); }}
                                className="px-3 py-1.5 rounded-full border border-gray-300 bg-white hover:bg-gray-50 text-sm text-gray-800"
                            >
                                {s}
                            </button>
                        }}
                    </div>
                }
            }}
        </div>

        {if searching {
            <p className="text-gray-500">Searching...</p>
        } else {
            if len(results) > 0 {
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    {[<ProductCard key={p["id"]} product={p} /> for p in results]}
                </div>
            } else {
                if searched {
                    <p className="text-gray-500">No results.</p>
                }
            }
        }}
    </div>;
}
