import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    field: String
  }

  static targets = ["map", "input"]

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
    this.initializeAutocomplete()
    
    const defaultLocation = { lat: -34.397, lng: 150.644 }
    
    const map = new google.maps.Map(this.mapTarget, {
      center: defaultLocation,
      zoom: 15
    })

    const marker = new google.maps.Marker({
      map: map,
      draggable: true
    })

    // Get location from clicked point
    map.addListener('click', (event) => {
      marker.setPosition(event.latLng)
      this.updateLocationField(event.latLng)
    })

    // Get location from dragged marker
    marker.addListener('dragend', () => {
      this.updateLocationField(marker.getPosition())
    })

    // Try to get user's current location
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          }
          map.setCenter(pos)
          marker.setPosition(pos)
          this.updateLocationField(pos)
        }
      )
    }
  }

  initializeAutocomplete() {
    const autocomplete = new google.maps.places.Autocomplete(this.inputTarget)
    
    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace()
      if (place.geometry) {
        const location = {
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng()
        }
        this.updateLocationField(location)
      }
    })
  }

  async updateLocationField(location) {
    try {
      const geocoder = new google.maps.Geocoder()
      const response = await geocoder.geocode({ location })
      
      if (response.results[0]) {
        const address = response.results[0].formatted_address
        this.inputTarget.value = address
      }
    } catch (error) {
      console.error('Geocoding failed:', error)
    }
  }
} 