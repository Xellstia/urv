import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    url: String,
    editMode: { type: Boolean, default: false }
  }

  static targets = [
    "nameWrapper",
    "editWrapper",
    "nameInput",
    "nameDisplay",
    "editForm"
  ]

  toggle(event) {
    if (!this.hasUrlValue || this.editModeValue) return
    if (this._shouldIgnore(event)) return

    event.preventDefault()
    event.stopPropagation()
    this._sendToggleRequest()
  }

  startEdit(event) {
    event.preventDefault()
    event.stopPropagation()
    this.editModeValue = true
    const details = event.target.closest("details")
    if (details) details.removeAttribute("open")
    if (this.hasNameInputTarget && this.hasNameDisplayTarget) {
      this.nameInputTarget.value = this.nameDisplayTarget.textContent.trim()
      requestAnimationFrame(() => {
        this.nameInputTarget.focus()
        this.nameInputTarget.select()
      })
    }
    this._refreshEditState()
  }

  cancelEdit(event) {
    event.preventDefault()
    this.editModeValue = false
    if (this.hasNameInputTarget && this.hasNameDisplayTarget) {
      this.nameInputTarget.value = this.nameDisplayTarget.textContent.trim()
    }
    this._refreshEditState()
  }

  async save(event) {
    event.preventDefault()
    if (!this.hasEditFormTarget) return

    const form = this.editFormTarget
    const token = this._csrfToken()
    const formData = new FormData(form)

    this._setSaving(true)
    try {
      const response = await fetch(form.action, {
        method: form.method.toUpperCase() || "PATCH",
        headers: {
          "X-CSRF-Token": token || "",
          "Accept": "application/json"
        },
        body: formData,
        credentials: "same-origin"
      })

      if (response.ok) {
        const payload = await response.json()
        if (this.hasNameDisplayTarget) {
          this.nameDisplayTarget.textContent = payload.name
        }
        if (this.hasNameInputTarget) {
          this.nameInputTarget.value = payload.name
        }
        this.editModeValue = false
        this._refreshEditState()
      } else {
        const payload = await response.json().catch(() => ({}))
        alert(payload.errors?.join("\n") || "Не удалось сохранить")
      }
    } catch (error) {
      console.error(error)
      alert("Не удалось сохранить")
    } finally {
      this._setSaving(false)
    }
  }

  _shouldIgnore(event) {
    return Boolean(event.target.closest("[data-template-category-ignore]"))
  }

  async _sendToggleRequest() {
    const tokenElement = document.querySelector("meta[name='csrf-token']")
    const response = await fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": tokenElement?.content || "",
        "Accept": "text/vnd.turbo-stream.html"
      },
      credentials: "same-origin"
    })

    if (!response.ok) {
      console.error("toggle collapse failed", response.status)
      return
    }

    const body = await response.text()
    if (body) {
      Turbo.renderStreamMessage(body)
    }
  }

  _refreshEditState() {
    if (!this.hasNameWrapperTarget || !this.hasEditWrapperTarget) return
    if (this.editModeValue) {
      this.nameWrapperTarget.classList.add("hidden")
      this.editWrapperTarget.classList.remove("hidden")
    } else {
      this.nameWrapperTarget.classList.remove("hidden")
      this.editWrapperTarget.classList.add("hidden")
    }
  }

  _setSaving(state) {
    if (!this.hasEditFormTarget) return
    const submit = this.editFormTarget.querySelector("input[type='submit']")
    if (submit) {
      submit.disabled = state
      submit.classList.toggle("opacity-60", state)
    }
  }

  _csrfToken() {
    return document.querySelector("meta[name='csrf-token']")?.content
  }
}
