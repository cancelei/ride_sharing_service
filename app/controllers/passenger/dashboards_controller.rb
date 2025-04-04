module Passenger
  class DashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_passenger_role

    def show
      @rides = current_user.passenger_profile.rides
      @active_ride = current_user.passenger_profile.rides.in_progress.first
      @recent_rides = current_user.passenger_profile.rides.completed.limit(5)
    end

    private

    def ensure_passenger_role
      unless current_user.role_passenger?
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
end
