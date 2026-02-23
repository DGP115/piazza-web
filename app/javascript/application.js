// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// DGP add.  Get Strada
// Prevent duplicate Strada registration in dev reloads
if (!window.__piazzaStradaInitialized) {
  window.__piazzaStradaInitialized = true
  await import("@hotwired/strada")
}