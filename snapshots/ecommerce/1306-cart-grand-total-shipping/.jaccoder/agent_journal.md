## Issues
- [turn 1] Edit guard incorrectly treated the existing manually routed `pages/` components as file-based routes; confirmed routes are explicitly mounted from `frontend.cl.jac` and left routing unchanged.

## Learnings
- Cart subtotal must multiply each variant price by its quantity; `get_cart` now returns subtotal, conditional shipping, and rounded grand total.
- This project uses manual routing in `frontend.cl.jac` despite placing page components under `pages/`.

## Last Action
Updated `services/cart.sv.jac` and `pages/CartPage.cl.jac` for quantity-aware subtotal, $5.99 shipping on non-empty carts, and a separate subtotal/shipping/grand total display. `jac check main.jac` succeeded; all 32 baseline tests passed.