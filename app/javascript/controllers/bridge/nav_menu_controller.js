import { BridgeComponent, BridgeElement } from "@hotwired/strada"

// Connects to data-controller="bridge--nav-menu"
export default class extends BridgeComponent {
  static component = "nav-menu"
  static targets = [ "item" ]
  
  connect() {
    this.element.classList.add("is-hidden")

    // Each constituent item in the navigation menu will be designated as a
    // Stimulus target. When the controller connects to the DOM, we iterate over all
    // the items, using the BridgeElement utility class to extract information
    // from each one, and send its details in a JSON message to the native app. We
    // also hide the element in the web page using a CSS class.

    const items =
      this.itemTargets
        .map(item => new BridgeElement(item))
        .map((item, index) => ({
          title: item.title,
          icon: item.bridgeAttribute("icon"),
          index
        }))
    
    this.send("connect", { items }, message => {
      const selectedIndex = message.data.selectedIndex
      const selectedItem = new BridgeElement(
        this.itemTargets[selectedIndex]
      )

      selectedItem.click()

    })
    
  }

  // We’re also sending a disconnect message so the app can do any required
  // cleanup to prevent duplicate menu items.
  disconnect() {
    this.send("disconnect")
  }
}
