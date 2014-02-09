class QuestsController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::QuestModule

  def index
    @quests = Quest.all
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def new
    @quest = Quest.new()
    parent = params[:id]
    if(parent != nil)
      @quest.parent_id = parent
      @quest.campaign = Quest.find(parent).campaign
    end

  end

  def create
    @quest = Quest.new(quest_params)

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

  def getTree
    quest = Quest.find(params[:id])
    render :text => generateQuestTree(quest)
  end

  def set_active
    quest = Quest.find(params[:id])
    user = User.find(current_user.id)
    user.active_quest_id = quest.id
    user.save
    render :nothing => true
  end

  def quest_params
    params.require(:quest).permit(:id, :description, :name, :parent_id, :campaign_id)
  end
end
