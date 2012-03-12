class ApplicationController < ActionController::Base
  before_filter :authorize
  
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
end
