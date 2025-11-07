import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    const frame = document.getElementById("modal")
    if (frame) frame.innerHTML = ""
  }
  esc(e) {
    if (e.key === "Escape") this.close()
  }
}
