Rails.application.routes.draw do
  # Root route
  root "pages#home"

  # Devise routes with custom controllers
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
  }, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }

  # User profile and preferences
  resource :profile, only: [ :show, :edit, :update ] do
    patch :update_notification_preferences, on: :member
  end

  # Rides
  resources :rides do
    member do
      patch :accept
      patch :start
      patch :complete
      patch :cancel
      get :share
    end

    collection do
      get :available
      get :history
    end

    resources :reviews, only: [ :create ]
    resources :followers, only: [ :create, :destroy ], controller: "ride_followers"
  end

  # Driver specific routes
  namespace :driver do
    resource :dashboard, only: [ :show ]
    resources :earnings, only: [ :index ]
    resource :availability, only: [ :update ]
    resources :rides, only: [ :index, :show ] do
      collection do
        get :current
        get :history
      end
    end
  end

  # Cab Association routes
  namespace :cab_association do
    resource :dashboard, only: [ :show ]
    resources :drivers
    resources :earnings, only: [ :index ]
    resources :reports, only: [ :index ]
  end

  # Admin routes
  namespace :admin do
    resource :dashboard, only: [ :show ]
    resources :users
    resources :cab_associations
    resources :rides
    resources :reports, only: [ :index ]
    resources :settings, only: [ :index, :update ]
  end

  # API routes for real-time updates
  namespace :api do
    namespace :v1 do
      resources :locations, only: [ :update ]
      resources :ride_statuses, only: [ :update ]
    end
  end

  # Notification preferences
  patch "notification_preferences", to: "notification_preferences#update"

  # Health check for monitoring
  get "health_check", to: "health_check#show"

  # Error pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
