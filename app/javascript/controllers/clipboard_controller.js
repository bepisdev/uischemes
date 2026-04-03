// Copies text to clipboard and shows brief "Copied!" feedback
// Usage: data-controller="clipboard"
//        data-action="click->clipboard#copy"
//        data-clipboard-text-value="<text to copy>"   OR
//        data-clipboard-target="source" on a <pre>/<code> whose textContent to copy

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "label"]
  static values  = { text: String }

  copy() {
    const text = this.hasTextValue && this.textValue
      ? this.textValue
      : this.hasSourceTarget ? this.sourceTarget.textContent : ""

    navigator.clipboard.writeText(text).then(() => {
      if (this.hasLabelTarget) {
        const original = this.labelTarget.textContent
        this.labelTarget.textContent = "Copied!"
        setTimeout(() => { this.labelTarget.textContent = original }, 1500)
      }
    })
  }
}
