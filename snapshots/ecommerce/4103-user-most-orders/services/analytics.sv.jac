"""Analytics service functions."""

import from models { Order }
import from services.catalog { ensure_seeded }


def:pub user_with_most_orders() -> str {
    ensure_seeded();

    counts: dict[str, int] = {};
    for o in [root -->][?:Order] {
        uid = o.user_id;
        counts[uid] = (counts.get(uid) or 0) + 1;
    }

    best_user: str = "";
    best_count: int = -1;
    for uid in counts {
        c = counts[uid];
        if c > best_count {
            best_count = c;
            best_user = uid;
        }
    }

    return best_user;
}
