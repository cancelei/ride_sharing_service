class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :phone,
      :role,
      { notification_preferences: {} },
      :whatsapp_number,
      :telegram_username
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :phone,
      { notification_preferences: {} },
      :whatsapp_number,
      :telegram_username
    ])
  end
end
