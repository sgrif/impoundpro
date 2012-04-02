class StripeWebhooksController < ApplicationController
  skip_before_filter :authorize, :has_subscription
  # GET /stripe_webhooks
  # GET /stripe_webhooks.json
  def index
    @stripe_webhooks = StripeWebhook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stripe_webhooks }
    end
  end

  # GET /stripe_webhooks/1
  # GET /stripe_webhooks/1.json
  def show
    @stripe_webhook = StripeWebhook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stripe_webhook }
    end
  end

  # GET /stripe_webhooks/new
  # GET /stripe_webhooks/new.json
  def new
    @stripe_webhook = StripeWebhook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @stripe_webhook }
    end
  end

  # GET /stripe_webhooks/1/edit
  def edit
    @stripe_webhook = StripeWebhook.find(params[:id])
  end

  # POST /stripe_webhooks
  # POST /stripe_webhooks.json
  def create

    if params[:stripe_webhook][:data][:object][:object] == "customer"
      user_token = params[:stripe_webhook][:data][:object][:id]
    else
      user_token = params[:stripe_webhook][:data][:object][:customer]
    end
    
    user = User.find_by_stripe_customer_token user_token
    if user
      webhook = user.stripe_webhooks.build(:type => params[:stripe_webhook][:type], :event_id => params[:stripe_webhook][:id])
      if webhook.save!
        process_webhook webhook
      end
    end
    
    render :nothing => true
  end

  # PUT /stripe_webhooks/1
  # PUT /stripe_webhooks/1.json
  def update
    @stripe_webhook = StripeWebhook.find(params[:id])

    respond_to do |format|
      if @stripe_webhook.update_attributes(params[:stripe_webhook])
        format.html { redirect_to @stripe_webhook, :notice => 'Stripe webhook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @stripe_webhook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stripe_webhooks/1
  # DELETE /stripe_webhooks/1.json
  def destroy
    @stripe_webhook = StripeWebhook.find(params[:id])
    @stripe_webhook.destroy

    respond_to do |format|
      format.html { redirect_to stripe_webhooks_url }
      format.json { head :no_content }
    end
  end

  def process_webhook(webhook)
    if webhook.type == "charge.succeeded"
      webhook.user.update_attribute(:paid, true)
    end
  end
end
