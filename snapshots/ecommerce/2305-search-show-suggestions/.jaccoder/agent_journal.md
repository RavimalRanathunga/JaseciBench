## Issues
- [turn 1] Jac placement markers (`to cl:`, `cl import`, `sv import`) were deprecated; ran `jac fix placement` and migrated to inferred placement.
- [turn 1] Vite dev server failed due to missing `node-releases` processed data and missing npm deps under `.jac/client`; fixed by installing `node-releases`, `vite`, and app npm deps into `.jac/client/node_modules`.
- [turn 1] `pages/` routing caused build/runtime errors; removed `pages/` modules and moved SearchPage into `components/` to keep manual Router working.

## Learnings
- In this snapshot, `pages/` is treated as file-based routing and conflicts with manual `<Router>` routing.
- Client event handlers should use `lambda (e: MouseEvent) { ... }` or named `def` handlers; avoid `lambda _: Type` syntax.

## Last Action
Added `search_suggestions()` server endpoint and rendered clickable suggestion chips on `/search` that populate the query input.