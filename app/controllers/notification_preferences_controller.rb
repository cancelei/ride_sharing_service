class NotificationPreferencesController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(notification_preferences_params)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "notification_preferences",
            partial: "users/notification_preferences",
            locals: { user: current_user }
          )
        }
        format.html { redirect_to profile_path, notice: "Notification preferences updated successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "notification_preferences",
            partial: "users/notification_preferences",
            locals: { user: current_user }
          )
        }
        format.html { render "profiles/edit" }
      end
    end
  end

  private

  def notification_preferences_params
    params.require(:user).permit(
      { notification_preferences: [ :email, :whatsapp, :telegram ] },
      :whatsapp_number,
      :telegram_username
    )
  end
end
