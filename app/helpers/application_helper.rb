module ApplicationHelper
  def user_dashboard
    case current_user.role
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
