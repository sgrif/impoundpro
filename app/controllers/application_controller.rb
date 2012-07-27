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
    if current_user && current_user.needs_subscription?
      redirect_to root_path
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
