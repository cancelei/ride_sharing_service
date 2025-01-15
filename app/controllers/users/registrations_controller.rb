class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :phone,
      :role,
      { notification_preferences: {} },
      :whatsapp_number,
      :telegram_username
    ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :phone,
      { notification_preferences: {} },
      :whatsapp_number,
      :telegram_username
    ])
  end

  def after_sign_up_path_for(resource)
    case resource.role
    when "passenger"
      passenger_dashboard_path
    when "driver"
      driver_dashboard_path
    when "cab_association"
      cab_association_dashboard_path
    else
      root_path
    end
  end
end
