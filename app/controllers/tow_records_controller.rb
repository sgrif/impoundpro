class TowRecordsController < ApplicationController
  # GET /tow_records
  # GET /tow_records.json
  def index
    @car = Car.find(params[:car_id])
    @tow_records = @car.tow_records

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tow_records }
    end
  end

  # GET /tow_records/1
  # GET /tow_records/1.json
  def show
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tow_record }
    end
  end

  # GET /tow_records/new
  # GET /tow_records/new.json
  def new
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tow_record }
    end
  end

  # GET /tow_records/1/edit
  def edit
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.find(params[:id])
  end

  # POST /tow_records
  # POST /tow_records.json
  def create
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.build(params[:tow_record])

    respond_to do |format|
      if @tow_record.save
        format.html { redirect_to car_tow_record_path(@car, @tow_record), notice: 'Tow record was successfully created.' }
        format.json { render json: @tow_record, status: :created, location: @tow_record }
      else
        format.html { render action: "new" }
        format.json { render json: @tow_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tow_records/1
  # PUT /tow_records/1.json
  def update
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.find(params[:id])

    respond_to do |format|
      if @tow_record.update_attributes(params[:tow_record])
        format.html { redirect_to car_tow_record_path(@car, @tow_record), notice: 'Tow record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tow_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tow_records/1
  # DELETE /tow_records/1.json
  def destroy
    @car = Car.find(params[:car_id])
    @tow_record = @car.tow_records.find(params[:id])
    @tow_record.destroy

    respond_to do |format|
      format.html { redirect_to @car }
      format.json { head :no_content }
    end
  end
end
