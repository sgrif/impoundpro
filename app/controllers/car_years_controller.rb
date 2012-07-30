class CarYearsController < ApplicationController
  # GET /car_years
  # GET /car_years.json
  def index
    @car_years = CarYear.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @car_years }
    end
  end

  # GET /car_years/1
  # GET /car_years/1.json
  def show
    @car_year = CarYear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @car_year }
    end
  end

  # GET /car_years/new
  # GET /car_years/new.json
  def new
    @car_year = CarYear.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @car_year }
    end
  end

  # GET /car_years/1/edit
  def edit
    @car_year = CarYear.find(params[:id])
  end

  # POST /car_years
  # POST /car_years.json
  def create
    @car_year = CarYear.new(params[:car_year])

    respond_to do |format|
      if @car_year.save
        format.html { redirect_to @car_year, notice: 'Car year was successfully created.' }
        format.json { render json: @car_year, status: :created, location: @car_year }
      else
        format.html { render action: "new" }
        format.json { render json: @car_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /car_years/1
  # PUT /car_years/1.json
  def update
    @car_year = CarYear.find(params[:id])

    respond_to do |format|
      if @car_year.update_attributes(params[:car_year])
        format.html { redirect_to @car_year, notice: 'Car year was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @car_year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /car_years/1
  # DELETE /car_years/1.json
  def destroy
    @car_year = CarYear.find(params[:id])
    @car_year.destroy

    respond_to do |format|
      format.html { redirect_to car_years_url }
      format.json { head :no_content }
    end
  end
end
