module Driver
    class DashboardsController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_driver_role

      def show
        @active_ride = current_user.driver_profile.rides.in_progress.first
        @recent_rides = current_user.driver_profile.rides.completed.limit(5)
      end

      private

      def ensure_driver_role
        unless current_user.driver_profile
          redirect_to root_path, alert: "Access denied."
        end
      end
    end
end
