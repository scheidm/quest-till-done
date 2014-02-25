# Controller for Quest
class QuestsController < ApplicationController

  require 'json_Generator'
  require 'Round/round_helper'
  include JsonGenerator::QuestModule
  include RoundHelper

  # Show all of user's quests
  # @return [Html] A list of quests of the user
  def index
    @quests = Quest.all
  end

  # Show the detail of a quest
  # @param id [Integer] Quest's id
  # @return [Html] Quest detail page with that id
  def show
    @quest = Quest.find(params[:id])
    @user = User.find(current_user.id)
    if(!@user.active_quest.nil?&&User.find(current_user.id).active_quest.id == @quest.id)
      @active_quest = true
    else
      @active_quest = false
    end
  end

  # Create new quest
  # @return [Html] New quest page
  def new
    @quest = Quest.new()
    parent = params[:id]
    if(parent != nil)
      @quest.parent_id = parent
      @quest.campaign = Quest.find(parent).campaign
    end
  end

  # Save new quest
  # @param quest_params [quest_params] field input from creation page
  # @return [Html] redirect back to the new quest page
  def create
    @quest = Quest.new(quest_params)
    @quest.status = 'Open'
    respond_to do |format|
      if @quest.save
        createRound(@quest, action_name, @quest.campaign)
        format.html { redirect_to campaign_path(@quest.campaign), notice: 'Quest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest.campaign }
      else
        format.html { render action: 'new'}
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # Edit existing quest
  # @param id [Integer] Quest's id
  # @return [Html] Quest's editing page
  def edit
    @quest = Quest.find(params[:id])
  end

  # Update quest changes and save the changes
  # @param quest_params [quest_params] field input from creation page
  # @return [Html] redirect back to quest's campaign page
  def update
    @quest = Quest.find(params[:id])
    respond_to do |format|
      if @quest.update(quest_params)
        createRound(@quest, action_name, @quest.campaign)
        format.html { redirect_to @quest, notice: 'Quest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render quest: 'edit' }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete quest and all the records it associated with
  # @param id [Integer] Quest's id
  # @return [Html] redirect back to quest's campaign page
  def destroy
    createRound(@quest, action_name, @quest.campaign)
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_path }
      format.json { head :no_content }
    end
  end

  # Get Json for generating tree view
  # @param id [Integer] Quest's id
  # @return [JSON] quest's information in JSON format
  def getTree
    quest = Quest.find(params[:id])
    render :text => generateQuestTree(quest)
  end

  # Set quest as user's current active quest
  # @param id [Integer] Quest's id
  def set_active
    quest = Quest.find(params[:id])
    user = User.find(current_user.id)
    user.active_quest_id = quest.id
    user.save
    render :nothing => true
  end

  # Define allowed parameter for a Campaign model
  # @param id [Integer] Quest's id
  # @param description [String] Quest's description
  # @param parent_id [Integer] Quest's parent quest id
  # @param campaign_id [Integer] Quest's campaign id
  # @param user_id [Integer] Owner's user_id
  # @param status [String] Quest's status
  # @param importance [Boolean] Quest importance check
  def quest_params
    params.require(:quest).permit(:id, :description, :name, :parent_id, :campaign_id, :user_id, :status, :importance)
  end
end
