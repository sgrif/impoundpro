class UsersController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create, :forgot_password, :send_reset_link, :reset_password, :paypal_checkout, :ipn]
  
  # GET /user
  def show
    #TODO Find a use for this page
    @user = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /user/new
  def new
    @user = User.new

    if params[:PayerID]
      @user.paypal_customer_token = params[:PayerID]
      @user.paypal_payment_token = params[:token]
      @user.email = @user.paypal.checkout_details.email
    end
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
        UserMailer.welcome(@user, login_url)
        format.html { redirect_to login_path, :notice => 'Account was successfully created. Please log in to continue.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
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
      if @user.update_attributes(params[:user])
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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to logout_url, :alert => 'Your account has been cancelled' }
      format.json { head :no_content }
    end
  end
  
  # GET /paypal/checkout
  def paypal_checkout
    user = User.new
    redirect_to user.paypal.checkout_url(
      :return_url => new_user_url,
      :cancel_url => root_url,
      :ipn_url => paypal_ipn_url
    )
  end
  
  # POST /paypal/ipn
  def ipn
    notification = PayPal::Recurring::Notification.new(params)
    Rails.logger.info "Valid: #{notification.valid?}"
    Rails.logger.info "Completed: #{notification.completed?}"
    Rails.logger.info "Verified: #{notification.verified?}"
    Rails.logger.info PayPal::Recurring.email
    render :nothing => true
  end

end
