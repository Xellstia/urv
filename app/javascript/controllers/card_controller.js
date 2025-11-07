import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "editLink"]
  static values = {
    frameId: String,
    editUrl: String
  }

  connect() {
    this.closeMenu = this.closeMenu.bind(this)
  }

  // Двойной клик по карточке — открыть форму редактирования в её turbo-frame
  openEdit() {
    if (this.hasEditLinkTarget) {
      this.editLinkTarget.click()
      return
    }
    // fallback: создаем временную ссылку c data-turbo-frame и кликаем
    const a = document.createElement("a")
    a.href = this.editUrlValue
    a.dataset.turboFrame = this.frameIdValue
    a.style.display = "none"
    this.element.appendChild(a)
    a.click()
    a.remove()
  }

  toggleMenu(event) {
    event.stopPropagation()
    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle("hidden")
      if (!this.menuTarget.classList.contains("hidden")) {
        // Закроем при клике вне
        document.addEventListener("click", this.closeMenu, { once: true })
      }
    }
  }

  closeMenu() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
