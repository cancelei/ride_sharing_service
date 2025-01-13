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

  def after_sign_in_path_for(resource)
    case resource.role
    when "passenger"
      rides_path
    when "driver"
      driver_dashboard_path
    when "cab_association"
      cab_association_dashboard_path
    when "admin"
      admin_dashboard_path
    else
      root_path
    end
  end
end
