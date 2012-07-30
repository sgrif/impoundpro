class CarMakesController < ApplicationController
  # GET /car_makes
  # GET /car_makes.json
  def index
    @car_makes = CarMake.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @car_makes }
    end
  end

  # GET /car_makes/1
  # GET /car_makes/1.json
  def show
    @car_make = CarMake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car_make }
    end
  end

  # GET /car_makes/new
  # GET /car_makes/new.json
  def new
    @car_make = CarMake.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @car_make }
    end
  end

  # GET /car_makes/1/edit
  def edit
    @car_make = CarMake.find(params[:id])
  end

  # POST /car_makes
  # POST /car_makes.json
  def create
    @car_make = CarMake.new(params[:car_make])

    respond_to do |format|
      if @car_make.save
        format.html { redirect_to @car_make, notice: 'Car make was successfully created.' }
        format.json { render json: @car_make, status: :created, location: @car_make }
      else
        format.html { render action: "new" }
        format.json { render json: @car_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /car_makes/1
  # PUT /car_makes/1.json
  def update
    @car_make = CarMake.find(params[:id])

    respond_to do |format|
      if @car_make.update_attributes(params[:car_make])
        format.html { redirect_to @car_make, notice: 'Car make was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @car_make.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_makes/1
  # DELETE /car_makes/1.json
  def destroy
    @car_make = CarMake.find(params[:id])
    @car_make.destroy

    respond_to do |format|
      format.html { redirect_to car_makes_url }
      format.json { head :no_content }
    end
  end
end
