class ApplicationController < ActionController::Base
  before_filter :authorize, :has_subscription, :init_breadcrumbs

  protect_from_forgery

  def current_user
    @current_user ||= User.scoped.includes(:cars).find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def redirect_if_logged_in
    redirect_to root_path if current_user
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

  def init_breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, url)
    url = eval(url) if url =~ /_path|_url/
    @breadcrumbs << {:name => name, :url => url}
  end

  def only_admin
    redirect_to root_path unless current_user.admin
  end
end
