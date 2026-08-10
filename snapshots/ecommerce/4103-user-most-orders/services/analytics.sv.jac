"""Analytics service endpoints.

Task: user_with_most_orders() returning the user_id (str). Ties broken arbitrarily.

Counts orders by Order.user_id across the seeded graph.
"""

import from models { Order }
import from services.catalog { ensure_seeded }


def:pub user_with_most_orders() -> str {
    ensure_seeded();

    counts: dict = {};
    for o in [root -->][?:Order] {
        uid = o.user_id;
        if not uid {
            continue;
        }
        if uid in counts {
            counts[uid] = (counts[uid] as int) + 1;
        } else {
            counts[uid] = 1;
        }
    }

    top_uid: str = "";
    top_n: int = -1;
    for uid in counts {
        n = counts[uid] as int;
        if n > top_n {
            top_uid = uid;
            top_n = n;
        }
    }

    return top_uid;
}
