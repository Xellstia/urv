import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    // Ищем ближайший turbo-frame и очищаем его содержимое
    const frame = this.element.closest("turbo-frame")
    if (frame) frame.innerHTML = ""
  }
}
