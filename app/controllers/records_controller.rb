class RecordsController < ApplicationController
  def index
    @records = Record.all
  end

  def show
    @record = Record.find(params[:id])
  end

  def new
    @record = Record.new()
  end

  def create
    @record = Record.new(record_params)
    @encounter = Encounter.last
    @encounter = Encounter.create if @encounter.nil? || @encounter.created_at<30.minutes.ago
    @record.encounter_id = @encounter.id
    @record.created_at = DateTime.now

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new'}
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def record_params
    params.require(:record).permit(:description, :encounter_id, :encounter)
  end
end
