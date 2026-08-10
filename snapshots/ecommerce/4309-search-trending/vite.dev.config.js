import { defineConfig } from "vite";

// This workspace runs Jac's dev server behind a proxy. In some environments
// Vite's HTML-proxy path can return an empty body, which in turn makes the
// client fail to import the entry module and shows the jac-error-reporter
// overlay. Disabling the overlay restores the app UI while keeping HMR.
export default defineConfig({
	server: {
		hmr: { overlay: false },
	},
});
