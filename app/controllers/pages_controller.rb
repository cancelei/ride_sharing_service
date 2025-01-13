class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    else
      render "home"
    end
  end
end
