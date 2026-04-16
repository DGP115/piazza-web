import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-element"
export default class extends Controller {
  connect() {
    console.log("remove_element controller connected")
  }

  remove() {
    this.element.remove()
  }
}
