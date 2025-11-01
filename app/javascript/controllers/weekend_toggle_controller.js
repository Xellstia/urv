import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  change() {
    const url = new URL(window.location)
    if (this.toggleTarget.checked) {
      url.searchParams.set("weekend", "true")
    } else {
      url.searchParams.delete("weekend")
    }
    window.location = url.toString()
  }
}