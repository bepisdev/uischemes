// Randomises the generator form inputs and submits
// Usage: data-controller="randomize" on the <form>
//        data-action="click->randomize#randomize" on the random button
//        data-randomize-target="picker"     on the color input[type=color]
//        data-randomize-target="hex"        on the hex text input
//        data-randomize-target="mood"       on the mood <select>
//        data-randomize-target="harmony"    on the harmony <select>
//        data-randomize-target="variations" on the variations <select>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker", "hex", "mood", "harmony", "variations"]

  randomize() {
    const hex = this.#randomHex()
    this.pickerTarget.value  = hex
    this.hexTarget.value     = hex
    this.moodTarget.value    = this.#randomOption(this.moodTarget)
    this.harmonyTarget.value = this.#randomOption(this.harmonyTarget)
    if (this.hasVariationsTarget) {
      this.variationsTarget.value = this.#randomOption(this.variationsTarget)
    }
    this.element.requestSubmit()
  }

  #randomHex() {
    const r = () => Math.floor(Math.random() * 256).toString(16).padStart(2, "0")
    return `#${r()}${r()}${r()}`
  }

  #randomOption(selectEl) {
    const options = Array.from(selectEl.options)
    return options[Math.floor(Math.random() * options.length)].value
  }
}
