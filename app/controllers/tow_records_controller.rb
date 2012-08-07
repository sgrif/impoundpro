class TowRecordsController < ApplicationController
  # GET /tow_records
  # GET /tow_records.json
  def index
    @tow_records = TowRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tow_records }
    end
  end

  # GET /tow_records/1
  # GET /tow_records/1.json
  def show
    @tow_record = TowRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tow_record }
    end
  end

  # GET /tow_records/new
  # GET /tow_records/new.json
  def new
    @tow_record = TowRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tow_record }
    end
  end

  # GET /tow_records/1/edit
  def edit
    @tow_record = TowRecord.find(params[:id])
  end

  # POST /tow_records
  # POST /tow_records.json
  def create
    @tow_record = TowRecord.new(params[:tow_record])

    respond_to do |format|
      if @tow_record.save
        format.html { redirect_to @tow_record, notice: 'Tow record was successfully created.' }
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
    @tow_record = TowRecord.find(params[:id])

    respond_to do |format|
      if @tow_record.update_attributes(params[:tow_record])
        format.html { redirect_to @tow_record, notice: 'Tow record was successfully updated.' }
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
    @tow_record = TowRecord.find(params[:id])
    @tow_record.destroy

    respond_to do |format|
      format.html { redirect_to tow_records_url }
      format.json { head :no_content }
    end
  end
end
