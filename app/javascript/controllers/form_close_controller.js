import { Controller } from "@hotwired/stimulus"

// Закрывает форму при клике вне её области
export default class extends Controller {
  static targets = ["form"]

  connect() {
    // Добавляем обработчик клика на document при подключении контроллера
    this.boundHandleClick = this.handleClick.bind(this)
    // Используем небольшую задержку, чтобы не закрывать форму сразу при открытии
    setTimeout(() => {
      document.addEventListener("click", this.boundHandleClick, true)
    }, 100)
  }

  disconnect() {
    // Удаляем обработчик при отключении контроллера
    document.removeEventListener("click", this.boundHandleClick, true)
  }

  handleClick(event) {
    // Проверяем, что клик был вне формы
    if (this.hasFormTarget && !this.formTarget.contains(event.target)) {
      // Проверяем, что клик не был на кнопке, которая открывает форму
      const isFormButton = event.target.closest('[data-turbo-frame]')
      if (isFormButton) {
        return // Не закрываем, если клик был на кнопке открытия формы
      }

      // Проверяем, что клик не был внутри самой формы
      if (this.formTarget.contains(event.target)) {
        return
      }

      // Проверяем, что клик не был на кнопке внутри формы (submit, cancel)
      const isFormButtonInside = event.target.closest('button[type="submit"]') || 
                                  event.target.closest('a.btn-ghost')
      if (isFormButtonInside && this.formTarget.contains(isFormButtonInside)) {
        return // Не закрываем, если клик был на кнопке внутри формы
      }

      // Закрываем форму
      this.closeForm()
    }
  }

  closeForm() {
    const turboFrame = this.element.closest('turbo-frame')
    if (!turboFrame) return

    // Проверяем, есть ли template с карточкой для отмены (режим редактирования)
    const cardTemplate = document.getElementById(turboFrame.id + '__card')
    if (cardTemplate) {
      // В режиме редактирования - восстанавливаем карточку
      turboFrame.innerHTML = cardTemplate.innerHTML
    } else {
      // В режиме создания - просто очищаем frame
      turboFrame.replaceChildren()
    }
  }
}

