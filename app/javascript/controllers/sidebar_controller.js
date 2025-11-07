import { Controller } from "@hotwired/stimulus"

// Управляет фиксированным сайдбаром (под топ-баром).
// Логика: нажатие по бургеру переключает translate на <aside id="sidebar">,
// а также добавляет/убирает отступ слева у <main id="main"> на md+.
export default class extends Controller {
  static targets = ["aside"]

  connect() {
    // при загрузке: на md+ показываем, на мобильных скрыто
    this._applyMainMargin()
    // закрытие по Escape на мобилках
    this._esc = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._esc)
  }

  disconnect() {
    document.removeEventListener("keydown", this._esc)
  }

  toggle() {
    const open = this.asideTarget.classList.contains("translate-x-0")
    open ? this.close() : this.open()
  }

  open() {
    this.asideTarget.classList.remove("-translate-x-full")
    this.asideTarget.classList.add("translate-x-0")
    this._applyMainMargin(true)
  }

  close() {
    // на md+ тоже можно складывать
    this.asideTarget.classList.remove("translate-x-0")
    this.asideTarget.classList.add("-translate-x-full")
    this._applyMainMargin(false)
  }

  _applyMainMargin(forceOpen = null) {
    const main = document.getElementById("main")
    if (!main) return

    const isOpen =
      forceOpen === true
        ? true
        : forceOpen === false
          ? false
          : this.asideTarget.classList.contains("translate-x-0")

    // на больших экранах двигаем контент, на мелких — пускай перекрывается
    if (isOpen) {
      main.classList.add("md:ml-64")
    } else {
      main.classList.remove("md:ml-64")
    }
  }
}
