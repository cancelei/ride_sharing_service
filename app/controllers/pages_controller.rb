class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  
  def home
    if user_signed_in?
      redirect_to after_sign_in_path
    end
  end
  
  private
  
  def after_sign_in_path
    case current_user.role
    when 'passenger'
      rides_path
    when 'driver'
      driver_dashboard_path
    when 'cab_association'
      cab_association_dashboard_path
    when 'admin'
      admin_dashboard_path
    else
      root_path
    end
  end
end 