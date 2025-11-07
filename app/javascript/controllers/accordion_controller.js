import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]
  toggle(event) {
    const panel = event.currentTarget.parentElement.querySelector("[data-accordion-target='panel']")
    if (panel) panel.classList.toggle("hidden")
  }
}
