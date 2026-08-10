## Issues
- [turn 1] SearchPage.cl.jac: fixed client-side mount fetch by using `async can with entry` and proper JSX slot syntax (no redundant `{...}` wrapping inside slot bodies).

## Learnings
- Client Jac uses `async can with entry` for mount effects; avoid JS-style `useEffect`.
- In JSX statement slots, nested `if/for` blocks should not be wrapped in `{...}`.

## Last Action
Added `search_suggestions()` server endpoint and rendered clickable "Try:" suggestion chips on /search; wired endpoint into main.jac and validated build.
