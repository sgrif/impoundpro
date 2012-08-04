#TODO Prompt user to finish user setup
class UsersController < ApplicationController
  skip_before_filter :has_subscription
  skip_before_filter :authorize, only: [:new, :create, :forgot_password, :send_reset_link, :reset_password]
  before_filter :redirect_if_logged_in, only: [:new, :create]

  # GET /user
  def show
    @user = current_user
    render :edit
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /user/edit
  def edit
    @user = current_user
  end

  # GET /user/subscribe
  def subscribe
    @user = current_user
  end

  # POST /user
  # POST /user.json
  def create
    email = params[:user].delete :email
    @user = User.new(params[:user])
    @user.email = email

    respond_to do |format|
      if @user.save
        @user.welcome
        login(@user)
        format.html { redirect_to root_path,
          flash: { success_title: 'Congratulations!', success: 'You registered successfully.' } }
        format.json { render json: @user, status: :created, location: @user }
      else
        @user.stripe_card_token = nil if @user.errors[:base].count > 0
        @body_class = :gatekeeper
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user
  # PUT /user.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_with_payment(params[:user], as: (:admin if current_user.admin))
        @user.send_password_changed_notice
        format.html { redirect_to root_path, flash: { success: 'Profile changed successfully.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user
  # DELETE /user.json
  def destroy
    @user = current_user
    @user.cancel

    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Your subscription has been cancelled' }
      format.json { head :no_content }
    end
  end
end
