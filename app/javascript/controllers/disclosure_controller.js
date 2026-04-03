// Toggles a hidden content panel
// Usage: data-controller="disclosure"
//        data-action="click->disclosure#toggle" on the trigger button
//        data-disclosure-target="content"        on the panel to show/hide

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.hidden = !this.contentTarget.hidden
  }
}
