class SessionsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :has_subscription

  def new
  end

  def create
    user = User.find_by_email(params[:login][:email])
    if user && user.authenticate(params[:login][:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end

      redirect_to root_url
    else
      redirect_to login_url, :flash => { :error => "Invalid user/password combination" }
    end
  end

  def destroy
    cookies.delete(:auth_token)

    redirect_to login_url, :notice => (flash[:notice] || "Logged Out")
  end
end
