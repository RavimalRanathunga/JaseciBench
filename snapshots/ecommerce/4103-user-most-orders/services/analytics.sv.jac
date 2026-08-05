"""Analytics service: simple read-only aggregate queries."""

import from services.catalog { ensure_seeded }
import from models { Order }


def:pub user_with_most_orders() -> str {
    ensure_seeded();

    counts: dict[str, int] = {};
    for o in [root -->][?:Order] {
        uid = o.user_id;
        if uid not in counts {
            counts[uid] = 0;
        }
        counts[uid] = counts[uid] + 1;
    }

    best_user = "";
    best_count = -1;
    for uid in counts {
        c = counts[uid];
        if c > best_count {
            best_count = c;
            best_user = uid;
        }
    }

    return best_user;
}
