import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["whatsappFields", "telegramFields"]

  connect() {
    this.toggleFields()
  }

  toggleFields() {
    const whatsappEnabled = this.element.querySelector('[name="user[notification_preferences][whatsapp]"]').checked
    const telegramEnabled = this.element.querySelector('[name="user[notification_preferences][telegram]"]').checked

    if (this.hasWhatsappFieldsTarget) {
      this.whatsappFieldsTarget.classList.toggle("hidden", !whatsappEnabled)
    }

    if (this.hasTelegramFieldsTarget) {
      this.telegramFieldsTarget.classList.toggle("hidden", !telegramEnabled)
    }
  }
} 