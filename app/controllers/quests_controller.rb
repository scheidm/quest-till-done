class QuestsController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::QuestModule

  def index
    @quests = Quest.all
  end

  def show
    @quest = Quest.find(params[:id])
    if(User.find(current_user.id).active_quest.id == @quest.id)
      @active_quest = true
    else
      @active_quest = false
    end
  end

  def new
    @quest = Quest.new()
    parent = params[:id]
    if(parent != nil)
      @quest.parent_id = parent
      @quest.campaign = Quest.find(parent).campaign
    end
    @status = [['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ']]
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.status = 'Open'
    respond_to do |format|
      if @quest.save
        format.html { redirect_to campaign_path(@quest.campaign), notice: 'Quest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest.campaign }
      else
        format.html { render action: 'new'}
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @quest = Quest.find(params[:id])
  end

  # PATCH/PUT /quests/1
  # PATCH/PUT /quests/1.json
  def update
    @quest = Quest.find(params[:id])
    respond_to do |format|
      if @quest.update(quest_params)
        format.html { redirect_to @quest, notice: 'Quest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render quest: 'edit' }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1
  # DELETE /quests/1.json
  def destroy
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_path }
      format.json { head :no_content }
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
    params.require(:quest).permit(:id, :description, :name, :parent_id, :campaign_id, :user_id, :status, :importance)
  end
end
