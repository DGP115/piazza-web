// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// DGP add.  Get Strada
// Prevent duplicate Strada registration in dev reloads
if (!window.__piazzaStradaInitialized) {
  window.__piazzaStradaInitialized = true
  import("@hotwired/strada").catch((error) => {
    console.error("Failed to load Strada", error)
  })
}