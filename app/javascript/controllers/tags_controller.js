import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tags"
export default class extends Controller {
  static targets = [ "template", "tagscontainer", "input"]
  
  connect() {
    console.log("tags controller connected")
  }

  addTag() {
    // Get user's entry for the tag from the input field
    const tagvalue = this.inputTarget.value.trim()
    if (tagvalue === "") {
      return
    }

    let templateHtml = this.templateTarget.innerHTML

    // Replace the placeholder value in the template with the actual value from the input field.
    // A regex is used for that.
    templateHtml = templateHtml.replace(/{value}/g, tagvalue)

    this.tagscontainerTarget.insertAdjacentHTML("beforeend", templateHtml)
    // Clear the input field after adding the tag
    this.inputTarget.value = ""
  }
}
