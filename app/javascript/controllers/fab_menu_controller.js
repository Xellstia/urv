import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "chevron"]

  connect() {
    this._outside = (e) => {
      if (!this.element.contains(e.target)) this.close()
    }
    document.addEventListener("click", this._outside)
  }

  disconnect() {
    document.removeEventListener("click", this._outside)
  }

  toggle(e) {
    e.preventDefault()
    e.stopPropagation()
    if (this.menuTarget.classList.contains("pointer-events-none")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    // показать
    this.menuTarget.classList.remove("pointer-events-none", "opacity-0", "scale-95")
    this.menuTarget.classList.add("opacity-100", "scale-100")
    // повернуть стрелку
    this.chevronTarget.classList.add("rotate-180")
    this.chevronTarget.classList.remove("rotate-0")
  }

  close() {
    // спрятать
    this.menuTarget.classList.add("pointer-events-none", "opacity-0", "scale-95")
    this.menuTarget.classList.remove("opacity-100", "scale-100")
    // вернуть стрелку
    this.chevronTarget.classList.remove("rotate-180")
    this.chevronTarget.classList.add("rotate-0")
  }
}
