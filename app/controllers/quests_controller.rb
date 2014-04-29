# Controller for Quest
class QuestsController < ApplicationController

  require 'json_generator'
  include JsonGenerator::QuestModule
  include RoundHelper
  include GithubHelper

  # Will show all of user's quests
  # @return [Html] A list of quests of the user
  def index
    @quests = Quest.all
  end

  # Will show the detail of a quest
  # @param id [Integer] Quest's id
  # @return [Html] Quest detail page with that id
  def show
    @quest = Quest.friendly.find(params[:id])
    if(!@user.active_quest.nil?&&User.find(@user.id).active_quest.id == @quest.id)
      @active_quest = true
    else
      @active_quest = false
    end

    #reverse history but direct to new

    if request.path != quest_path(@quest)
      redirect_to @quest, status: :moved_permanently
    end
  end

  # Will create a new quest
  # @return [Html] New quest page
  def new
    @quest = Quest.new()
    @quest.group_id=params[:group_id]||@user.wrapper_group.id
    parent = params[:id]
    if (parent != nil)
      @quest.parent_id = parent
      parent_quest = Quest.find(parent)
      @quest.campaign_id = parent_quest.campaign_id || parent_quest.id
    end
  end

  # Save new quest
  # @param quest_params [quest_params] field input from creation page
  # @return [Html] redirect back to the new quest page
  def create
    @quest = Quest.new(quest_params)
    @quest.group_id = @user.wrapper_group.id
    @quest.status = 'Open'
    @quest.description = nil if @quest.description==""
    respond_to do |format|
      if @quest.save
        create_round(@quest, action_name, @quest.campaign)
        format.html { redirect_to campaign_path(@quest.campaign), notice: 'Quest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quest.campaign }
      else
        format.html { render action: 'new' }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end

    # Sync with Github
    quest_parent = Campaign.find(@quest.campaign_id)
    if quest_parent.vcs
      githubinfo = GithubRepo.where(campaign_id: quest_parent.id).first
      open_issue(githubinfo.github_user, githubinfo.project_name, @quest)
    end

  end

  # Will allow user to edit existing quest
  # @param id [Integer] Quest's id
  # @return [Html] Quest's editing page
  def edit
    @quest = Quest.friendly.find(params[:id])
  end

  # Will update quest changes and save the changes
  # @param quest_params [quest_params] field input from creation page
  # @return [Html] redirect back to quest's campaign page
  def update
    @quest = Quest.friendly.find(params[:id])
    respond_to do |format|
      if @quest.save
        if params['quest']['status']=="Closed"
          #sync with github
          parent_campaign = Campaign.find(@quest.campaign_id)
          if parent_campaign.vcs
            github_info = GithubRepo.where(campaign_id: parent_campaign.id).first
            close_issue(github_info.github_user, github_info.project_name, @quest.issue_no)
          end
          if @quest.id==@user.active_quest.id
            @user.active_quest=Quest.where('user_id = (?)', @quest.user_id).where('name = (?)', 'Unsorted Musings').first
            @user.save
          end
        end
      end



      if @quest.update(quest_params)
        create_round(@quest, action_name, @quest.campaign)
        format.html { redirect_to @quest, notice: 'Quest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render quest: 'edit' }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # Will delete quest and all the records it associated with
  # @param id [Integer] Quest's id
  # @return [Html] redirect back to quest's campaign page
  def destroy
    @quest = Quest.friendly.find(params[:id])
    create_round(@quest, action_name, @quest.campaign)
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_path }
      format.json { head :no_content }
    end
  end

  # Will generate JSON to display tree relations for a quest
  # @param id [Integer] Quest's id
  # @return [JSON] quest's information in JSON format
  def getTree
    quest = Quest.friendly.find(params[:id])
    render :text => generateQuestTree(quest)
  end

  # Will set a specified quest as user's current active quest
  # @param id [Integer] Quest's id
  def set_active
    quest = Quest.friendly.find(params[:id])
    user = User.find(@user.id)
    user.active_quest_id = quest.id
    user.save
    render :nothing => true
  end

  # Will restrict parameters to those formally specified
  # @param id [Integer] Quest's id
  # @param description [String] Quest's description
  # @param parent_id [Integer] Quest's parent quest id
  # @param campaign_id [Integer] Quest's campaign id
  # @param user_id [Integer] Owner's user_id
  # @param status [String] Quest's status
  # @param importance [Boolean] Quest importance check
  def quest_params
    params.require(:quest).permit(:id, :description, :name, :parent_id, :campaign_id, :user_id, :status, :importance, :deadline)
  end


end
