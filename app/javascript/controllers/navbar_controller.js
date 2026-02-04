import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = [ "burgerMenuButton", "menuDropdown" ]

  connect() {
    console.log("Navbar controller connected")
  }
  
  toggle() {
    this.burgerMenuButtonTarget.classList.toggle("is-active")
    this.menuDropdownTarget.classList.toggle("is-active")
  }
}
