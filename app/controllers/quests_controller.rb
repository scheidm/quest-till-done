class QuestsController < ApplicationController
  def index
    @quests = Quest.all
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def new
    if session[:state].nil? || session[:state].casecmp('Stopped') == 0
      flash[:notice] = 'No active encounter.'
      redirect_to action: 'index'
    end
    @quest = Quest.new()
  end

  def create
    @quest = Quest.new(record_params)

    respond_to do |format|
      if @quest.save
        format.html { redirect_to @quest, notice: 'Quest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest }
      else
        format.html { render action: 'new'}
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  def quest_params
    params.require(:quest).permit(:description, :name)
  end
end