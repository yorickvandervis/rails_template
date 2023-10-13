import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dark", "light"]

  connect() {
    this.assignCurrentMode()
  }

  toggle() {
    this.lightTarget.classList.toggle('hidden')
    this.darkTarget.classList.toggle('hidden')
    this.element.classList.toggle('rotate-[20deg]');

    // if set via local storage previously
    if (localStorage.getItem('color-theme')) {
      if (localStorage.getItem('color-theme') === 'light') {
        this.setDarkMode()
      } else {
        this.setLightMode()
      }

      // if NOT set via local storage previously
    } else {
      if (document.documentElement.classList.contains('dark')) {
        this.setLightMode()
      } else {
        this.setDarkMode()
      }
    }
  }

  assignCurrentMode() {
    if (localStorage.getItem('color-theme') === 'dark' || (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      this.lightTarget.classList.remove('hidden')
      this.darkTarget.classList.add('hidden')
      document.documentElement.classList.add('dark')
    } else {
      this.lightTarget.classList.add('hidden')
      this.darkTarget.classList.remove('hidden')
      document.documentElement.classList.remove('dark')
    }
  }

  setLightMode() {
    this.lightTarget.classList.add('hidden')
    this.darkTarget.classList.remove('hidden')
    document.documentElement.classList.remove('dark')
    localStorage.setItem('color-theme', 'light')
  }

  setDarkMode() {
    this.lightTarget.classList.remove('hidden')
    this.darkTarget.classList.add('hidden')
    document.documentElement.classList.add('dark')
    localStorage.setItem('color-theme', 'dark')
  }
}