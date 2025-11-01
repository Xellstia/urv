import { Controller } from "@hotwired/stimulus"

// Преобразует "1h30m", "1:30", "90" в minutes_spent (скрытое поле)
export default class extends Controller {
  static targets = ["visible", "hidden"]

  connect() {
    this.visibleTarget.addEventListener("input", () => this.parse())
  }

  parse() {
    const v = this.visibleTarget.value.trim().toLowerCase()
    let minutes = 0

    if (/^\d+:\d{1,2}$/.test(v)) {
      const [h, m] = v.split(":").map(Number)
      minutes = (h || 0) * 60 + (m || 0)
    } else {
      const h = (v.match(/(\d+)\s*h/) || [0, 0])[1]
      const m = (v.match(/(\d+)\s*m/) || [0, 0])[1]
      if (h || m) minutes = (parseInt(h || 0) * 60) + parseInt(m || 0)
      else if (/^\d+$/.test(v)) minutes = parseInt(v, 10)
    }

    this.hiddenTarget.value = isFinite(minutes) ? minutes : 0
  }
}