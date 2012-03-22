class ApplicationController < ActionController::Base
  before_filter :authorize, :has_subscription
  
  protect_from_forgery
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  protected
  
  def authorize
    unless current_user
      redirect_to login_url, :notice => "Please log in"
    end
  end

  def has_subscription
    if current_user
      unless current_user.paid == true
        redirect_to edit_user_path, :alert => "There was a problem with your subscription, please update your credit card information."
      end
    end
  end
end
