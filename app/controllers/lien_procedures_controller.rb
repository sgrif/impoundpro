class LienProceduresController < ApplicationController
  layout "secure"

  # GET /lien_procedures
  # GET /lien_procedures.json
  def index
    @car = Car.find(params[:car_id])
    @lien_procedures = @car.lien_procedures

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lien_procedures }
    end
  end

  # GET /lien_procedures/1
  # GET /lien_procedures/1.json
  def show
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lien_procedure }
    end
  end

  # GET /lien_procedures/new
  # GET /lien_procedures/new.json
  def new
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lien_procedure }
    end
  end

  # GET /lien_procedures/1/edit
  def edit
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.find(params[:id])
  end

  # POST /lien_procedures
  # POST /lien_procedures.json
  def create
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.build(params[:lien_procedure])

    respond_to do |format|
      if @lien_procedure.save
        format.html { redirect_to @car, notice: 'Lien procedure was started successfully.' }
        format.json { render json: @lien_procedure, status: :created, location: @lien_procedure }
      else
        format.html { render action: "new" }
        format.json { render json: @lien_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lien_procedures/1
  # PUT /lien_procedures/1.json
  def update
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.find(params[:id])
    @lien_procedure.active = params[:active] unless params[:active].nil?

    respond_to do |format|
      if @lien_procedure.update_attributes(params[:lien_procedure])
        format.html { redirect_to @car, notice: 'Lien procedure was updated successfully.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lien_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lien_procedures/1
  # DELETE /lien_procedures/1.json
  def destroy
    @car = Car.find(params[:car_id])
    @lien_procedure = @car.lien_procedures.find(params[:id])
    @lien_procedure.destroy

    respond_to do |format|
      format.html { redirect_to @car }
      format.json { head :no_content }
    end
  end
end
