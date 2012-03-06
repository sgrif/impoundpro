class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create, :forgot_password, :send_reset_link, :reset_password, :paypal_checkout]
  
  # GET /user
  def show
    #TODO Find a use for this page
    @user = User.find(session[:user_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
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
    @user = User.find(session[:user_id])
  end

  # POST /user
  # POST /user.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'Account was successfully created. Please log in to continue.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user
  # PUT /user.json
  def update
    @user = User.find(session[:user_id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_path, notice: 'Account details successfully updated.' }
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
    @user = User.find(session[:user_id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to logout_url, alert: 'Your account has been cancelled' }
      format.json { head :no_content }
    end
  end
  
  # GET /paypal/checkout
  def paypal_checkout
    user = User.new
    redirect_to user.paypal.checkout_url(
      return_url: new_user_url,
      cancel_url: root_url
    )
  end
  
  # POST /paypal/ipn
  def ipn
    ipn_log = Logger.new(File.open("#{Rails.root}/log/ipn.log"))
    ipn_log.info params
  end

end
