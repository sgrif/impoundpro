class UsersController < ApplicationController
  skip_before_filter :has_subscription, :only => [:new, :create, :forgot_password, :send_reset_link, :reset_password, :edit, :update, :destroy]
  skip_before_filter :authorize, :only => [:new, :create, :forgot_password, :send_reset_link, :reset_password, :handle_stripe_event]
  
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

  # POST /user
  # POST /user.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save_with_payment
        @user.welcome
        format.html { redirect_to login_path, :notice => 'Account was successfully created. Please log in to continue.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        @user.stripe_card_token = nil if @user.errors[:base].count > 0
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user
  # PUT /user.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_with_payment(params[:user])
        @user.send_password_changed_notice
        format.html { redirect_to user_path, :notice => 'Account details successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user
  # DELETE /user.json
  def destroy
    @user = current_user
    @user.cancel

    respond_to do |format|
      format.html { redirect_to logout_url, :alert => 'Your account has been cancelled' }
      format.json { head :no_content }
    end
  end
end
