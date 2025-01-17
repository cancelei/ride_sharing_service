class CabAssociation::DashboardsController < ApplicationController
  before_action :ensure_cab_association_role

  def show
    @active_ride = current_user.cab_association_profile.rides.in_progress.first
    @recent_rides = current_user.cab_association_profile.rides.completed.limit(5)
  end

  private

  def ensure_cab_association_role
    unless current_user.cab_association
      redirect_to root_path, alert: "Access denied."
    end
  end
end
