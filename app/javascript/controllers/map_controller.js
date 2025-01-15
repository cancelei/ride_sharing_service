import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String
  }

  connect() {
    if (typeof google === 'undefined') {
      this.loadGoogleMapsAPI()
    } else {
      this.initializeMap()
    }
  }

  loadGoogleMapsAPI() {
    const script = document.createElement('script')
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&libraries=places`
    script.async = true
    script.defer = true
    script.onload = () => this.initializeMap()
    document.head.appendChild(script)
  }

  initializeMap() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords
          const mapOptions = {
            center: { lat: latitude, lng: longitude },
            zoom: 15,
            styles: this.mapStyles()
          }
          
          const map = new google.maps.Map(this.element, mapOptions)
          
          new google.maps.Marker({
            position: { lat: latitude, lng: longitude },
            map: map,
            title: 'Your Location'
          })
        },
        () => {
          // Handle location error
          const defaultLocation = { lat: -34.397, lng: 150.644 }
          const map = new google.maps.Map(this.element, {
            center: defaultLocation,
            zoom: 15
          })
        }
      )
    }
  }

  mapStyles() {
    return [
      {
        featureType: "poi",
        elementType: "labels",
        stylers: [{ visibility: "off" }]
      }
    ]
  }
} 