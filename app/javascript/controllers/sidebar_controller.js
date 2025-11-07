import { Controller } from "@hotwired/stimulus"

// Управляем ОДНИМ источником истины:
// - html[data-sb="1"]  => узкий режим
// - shell.sb-anim      => плавная анимация (включаем только после первого клика)
export default class extends Controller {
  static targets = ["aside"]

  connect() {
    // НИЧЕГО НЕ АНИМИРУЕМ при загрузке.
    // Начальное состояние уже применено в <head> через html[data-sb].
  }

  toggle() {
    // включаем анимацию только с первой интеракции
    if (!this.element.classList.contains("sb-anim")) {
      this.element.classList.add("sb-anim")
      void this.element.offsetWidth // форс-рефлоу
    }

    const html = document.documentElement
    const nowCollapsed = !(html.getAttribute("data-sb") === "1")

    if (nowCollapsed) {
      html.setAttribute("data-sb", "1")
      try { localStorage.setItem("sidebar:collapsed", "1") } catch(e) {}
    } else {
      html.removeAttribute("data-sb")
      try { localStorage.setItem("sidebar:collapsed", "0") } catch(e) {}
    }
  }
}
