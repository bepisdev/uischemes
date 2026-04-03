// Simple tab switcher
// Usage: data-controller="tabs"
//        data-tabs-target="tab"   data-panel="css"    on each tab button
//        data-tabs-target="panel" data-tab-id="css"   on each panel div

import { Controller } from "@hotwired/stimulus"

const ACTIVE_STYLE   = "background-color: var(--color-brand);"
const INACTIVE_STYLE = ""
const ACTIVE_TEXT    = "text-white"
const INACTIVE_TEXT  = "text-[--color-text-muted]"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    const active = this.tabTargets.find(t => t.dataset.active === "true")
    this.activate(active || this.tabTargets[0])
  }

  switch(event) {
    this.activate(event.currentTarget)
  }

  activate(tabEl) {
    if (!tabEl) return
    const panel = tabEl.dataset.panel

    this.tabTargets.forEach(t => {
      const isActive = t === tabEl
      t.dataset.active = isActive
      t.setAttribute("aria-selected", isActive)
      t.style.cssText = isActive ? ACTIVE_STYLE : INACTIVE_STYLE
      t.classList.toggle(ACTIVE_TEXT, isActive)
      t.classList.toggle(INACTIVE_TEXT, !isActive)
    })

    this.panelTargets.forEach(p => {
      p.hidden = p.dataset.tabId !== panel
    })
  }
}
