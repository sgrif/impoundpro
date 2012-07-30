class CarTrimsController < ApplicationController
  # GET /car_trims
  # GET /car_trims.json
  def index
    @car_trims = CarTrim.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @car_trims }
    end
  end

  # GET /car_trims/1
  # GET /car_trims/1.json
  def show
    @car_trim = CarTrim.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car_trim }
    end
  end

  # GET /car_trims/new
  # GET /car_trims/new.json
  def new
    @car_trim = CarTrim.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @car_trim }
    end
  end

  # GET /car_trims/1/edit
  def edit
    @car_trim = CarTrim.find(params[:id])
  end

  # POST /car_trims
  # POST /car_trims.json
  def create
    @car_trim = CarTrim.new(params[:car_trim])

    respond_to do |format|
      if @car_trim.save
        format.html { redirect_to @car_trim, notice: 'Car trim was successfully created.' }
        format.json { render json: @car_trim, status: :created, location: @car_trim }
      else
        format.html { render action: "new" }
        format.json { render json: @car_trim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /car_trims/1
  # PUT /car_trims/1.json
  def update
    @car_trim = CarTrim.find(params[:id])

    respond_to do |format|
      if @car_trim.update_attributes(params[:car_trim])
        format.html { redirect_to @car_trim, notice: 'Car trim was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @car_trim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_trims/1
  # DELETE /car_trims/1.json
  def destroy
    @car_trim = CarTrim.find(params[:id])
    @car_trim.destroy

    respond_to do |format|
      format.html { redirect_to car_trims_url }
      format.json { head :no_content }
    end
  end
end
