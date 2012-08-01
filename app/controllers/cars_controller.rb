class CarsController < ApplicationController
  skip_before_filter :has_subscription, :only => :index
  before_filter { add_breadcrumb "Cars", cars_path }
    before_filter :only => [:new, :create] { add_breadcrumb "Add New", new_car_path }
    before_filter :only => [:show, :edit, :update] { add_breadcrumb Car.find(params[:id]).to_s, car_path(params[:id]) }
      before_filter :only => [:edit, :update] { add_breadcrumb "Edit", edit_car_path(params[:id]) }

  # GET /cars
  # GET /cars.json
  def index
    @cars = current_user.cars

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cars }
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @car }
    end
  end

  # GET /cars/new
  # GET /cars/new.json
  def new
    @car = current_user.cars.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
  end

  # POST /cars
  # POST /cars.json
  def create
    vin = params[:car].delete :vin
    @car = Car.find_or_initialize_by_vin_and_user_id(vin, current_user.id)
    @car.override_check_vin = params[:override_check_vin]

    respond_to do |format|
      if @car.save
        format.html { redirect_to edit_car_path(@car) }
        format.json { render :json => @car, :status => :created, :location => @car }
      else
        format.html { render :action => "new" }
        format.json { render :json => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cars/1
  # PUT /cars/1.json
  def update
    @car = Car.find(params[:id])

    respond_to do |format|
      if @car.update_attributes(params[:car])
        format.html { redirect_to @car, :notice => 'Car was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    respond_to do |format|
      format.html { redirect_to cars_url, :notice => 'Car was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def unlock
    @car = Car.find(params[:id])

    unless @car.paid
      invoice = Stripe::InvoiceItem.create(
        :customer => @car.user.get_stripe_customer_token,
        :amount => 200,
        :currency => "usd",
        :description => "Unlocking fee for car #{@car.license_plate_number}"
      )
      redirect_to cars_path, :error => "There was an error processing your request." unless invoice
      @car.stripe_invoice_item_token = invoice.id
      @car.paid = true
      @car.save!
    end

    redirect_to cars_path
  end

  #TODO Make other dates changeable

  # GET /cars/1/owner_lien_notice.pdf
  def owner_lien_notice
    @car = Car.find(params[:id])
    @car.mail_notice_of_lien_date = Date.today
    @car.save

    respond_to do |format|
      format.pdf {render :layout => false} #owner_lien_notice.pdf.prawn
    end
  end

  # GET /cars/1/owner_lien_notice.pdf
  def lien_holder_lien_notice
    @car = Car.find(params[:id])
    @car.mail_notice_of_lien_date = Date.today
    @car.save

    respond_to do |format|
      format.pdf {render :layout => false} #lien_holder_lien_notice.pdf.prawn
    end
  end

  # GET /cars/1/owner_lien_notice.pdf
  def driver_lien_notice
    @car = Car.find(params[:id])
    @car.mail_notice_of_lien_date = Date.today
    @car.save

    respond_to do |format|
      format.pdf {render :layout => false} #driver_lien_notice.pdf.prawn
    end
  end

  # GET /cars/1/owner_mail_labels.pdf
  def owner_mail_labels
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #owner_mail_labels.pdf.prawn
    end
  end

  # GET /cars/1/lien_holder_mail_labels.pdf
  def lien_holder_mail_labels
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #lien_holder_mail_labels.pdf.prawn
    end
  end

  # GET /cars/1/driver_mail_labels.pdf
  def driver_mail_labels
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #driver_mail_labels.pdf.prawn
    end
  end

  # GET /cars/1/notice_of_public_sale.pdf
  def notice_of_public_sale
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #notice_of_public_sale.pdf.prawn
    end
  end

  # GET /cars/1/affidavit_of_resale.pdf
  def affidavit_of_resale
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #affidavit_of_resale.pdf.prawn
    end
  end

  # GET /cars/1/title_application.pdf
  def title_application
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #title_application.pdf.prawn
    end
  end

  # GET /cars/1/fifty_state_check.pdf
  def fifty_state_check
    @car = Car.find(params[:id])

    respond_to do |format|
      format.pdf {render :layout => false} #fifty_state_check.pdf.prawn
    end
  end

  # GET /cars/1/unclaimed_vehicles_report.pdf
  def unclaimed_vehicles_report
    @user = current_user
    @cars = @user.cars.where("date_towed <= '#{30.days.ago}'")

    respond_to do |format|
      format.pdf {render :layout => false} #unclaimed_vehicles_report.pdf.prawn
    end
  end



  protected

  def authorize_cars
    unless Car.find(params[:id]).user == current_user
      redirect_to cars_url
      logger.error "Attempt to access unowned car userid: #{current_user} carid: #{params[:id]}"
    end
  end

  def requires_unlocked
    unless Car.find(params[:id]).paid
      flash[:error] = "You must unlock the car before you can do that"
      redirect_to cars_path
    end
  end

  def has_cars
    redirect_to cars_url, :notice => "No cars to display" unless current_user.cars.count > 0
  end
end
