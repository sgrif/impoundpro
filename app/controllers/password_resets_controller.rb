class PasswordResetsController < ApplicationController
  skip_before_filter :authorize

  #GET /password_resets/new
  def new
  end

  #POST /password_resets/new
  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to login_url, notice: "Email sent with password reset instructions"
    else
      redirect_to new_password_reset_path, alert: "No account found for that email"
    end
  end

  #GET /password_resets/1/edit
  def edit
    @user = User.find_by_password_reset_token(params[:id])
    unless @user
      redirect_to new_password_reset_path, alert: "Invalid reset token"
    end
  end

  #PUT /password_resets/1
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset has expired"
    elsif @user.update_attributes(params[:user])
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end
end
