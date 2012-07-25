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
    if current_user and false
      unless current_user.paid == true
        redirect_to edit_user_path, :alert => "There was a problem with your subscription, please update your credit card information."
      end
    end
  end

  def login(user, remember_me=false)
    if remember_me
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end
end
