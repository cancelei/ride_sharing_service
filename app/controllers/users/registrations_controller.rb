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
      new_passenger_profile_path
    when "driver"
      new_driver_profile_path
    when "cab_association"
      new_cab_association_path
    else
      root_path
    end
  end
end
