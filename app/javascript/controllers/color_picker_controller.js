// Syncs <input type="color"> ↔ a hex text input
// Usage: data-controller="color-picker"
//        data-color-picker-target="picker" on the color input
//        data-color-picker-target="hex"    on the text input

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker", "hex"]

  connect() {
    // Initialise picker from whatever hex value is already in the text field
    if (this.hexTarget.value) {
      this.pickerTarget.value = this.hexTarget.value
    }
  }

  pickerChanged() {
    this.hexTarget.value = this.pickerTarget.value
  }

  hexChanged() {
    const val = this.hexTarget.value.trim()
    if (/^#[0-9A-Fa-f]{6}$/.test(val)) {
      this.pickerTarget.value = val
    }
  }
}
