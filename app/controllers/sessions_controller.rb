class SessionsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :has_subscription
  before_filter :redirect_if_logged_in, :only => :new

  def new
    @body_class = :gatekeeper
  end

  def create
    user = User.find_by_email(params[:login][:email])
    if user && user.authenticate(params[:login][:password])
      login(user, params[:remember_me])
      redirect_to cars_url
    else
      @body_class = :gatekeeper
      redirect_to login_url, :flash => { :error => "Invalid user/password combination" }
    end
  end

  def destroy
    cookies.delete(:auth_token)

    redirect_to login_url, :notice => (flash[:notice] || "Logged Out")
  end
end
