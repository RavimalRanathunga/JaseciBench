## Issues
- [turn 1] Vite HMR overlay: browserslist missing `node-releases/data/processed/envs.json` due to stale/corrupt client node_modules. Fixed by deleting `.jac/client/node_modules` and re-running `jac install`.
- [turn 1] Search page runtime error `useEffect is not defined`. Fixed by importing `useEffect` from react.

## Learnings
- This project uses file-based routing: pages must export a function returning `JsxPage`, not `JsxElement`.

## Last Action
Added `trending_searches()` server function and rendered `Trending:` terms on Search page; restored client build by reinstalling npm deps.