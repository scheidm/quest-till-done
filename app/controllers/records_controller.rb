class RecordsController < ApplicationController
  def index
    @records = Record.all
  end

  def show
    @record = Record.find(params[:id])
  end

  def new
    if session[:state].nil? || session[:state].casecmp('Stopped') == 0
      @records = Record.all
      flash[:notice] = 'No active pomodoro.'
       render action: 'index', notice: 'No active pomodoro.' , record: @records
    end
    @record = Record.new()
  end

  def create
    @record = Record.new(record_params)
    @pomodoro = Pomodoro.last
    @pomodoro = Pomodoro.create if @pomodoro.nil? || @pomodoro.created_at<30.minutes.ago
    @record.pomodoro_id = @pomodoro.id
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
    params.require(:record).permit(:description, :pomodoro_id, :pomodoro)
  end
end
