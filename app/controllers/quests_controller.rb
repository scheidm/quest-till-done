# Controller for Quest
class QuestsController < ApplicationController

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
    @is_quest=true
    @quest = Quest.find(params[:id])
    @actionable=@quest
    @campaign = @quest.campaign
    if @quest.status=='Closed' then
      @state_class="btn-danger"
      @effect="Open"
    else
      @state_class="btn-success"
      @effect="Close"
    end

    #reverse history but direct to new

    if request.path != quest_path(@quest)
      redirect_to @quest, status: :moved_permanently
    end
  end

  # Create new quest
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
    @quest.tag_list.add(params[:tag_list])
  end

  # Save new quest
  # @param quest_params [quest_params] field input from creation page
  # @return [Html] redirect back to the new quest page
  def create
    @quest = Quest.new(quest_params)
    @quest.group_id = @user.wrapper_group.id
    @quest.status = 'Open'
    @quest.description = nil if @quest.description==""
    path = @quest.parent.type == 'Campaign'? campaign_path(@quest.parent) : quest_path(@quest.parent)
    respond_to do |format|
      if @quest.save
        create_round(@quest, action_name.capitalize, @quest.campaign)
        format.html { redirect_to path, notice: 'Quest was successfully created.' }
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
      open_issue(@user, githubinfo.github_user, githubinfo.project_name, @quest)
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
      if @quest.save
        @quest.update_cleanup(@user)
      end

      if @quest.update(quest_params)
        create_round(@quest, action_name.capitalize, @quest.campaign)
        format.html { redirect_select }
        format.json { head :no_content }
      else
        format.html { render quest: 'edit' }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  def redirect_select
    @quest = Quest.find(params[:id])
    if @quest.status=="Closed"
      redirect_to @quest.parent, notice: 'Quest was successfully updated.'
    else
      redirect_to @quest, notice: 'Quest was successfully updated.'
    end
  end

  def toggle_state
    @quest = Quest.find(params[:id])
    action=@quest.toggle_state(@user)
    create_round(@quest, action, @quest.campaign)
    redirect_select
  end

  # Delete quest and all the records it associated with
  # @param id [Integer] Quest's id
  # @return [Html] redirect back to quest's campaign page
  def destroy
    @quest = Quest.find(params[:id])
    @campaign=@quest.campaign
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to campaign_path(@campaign) }
      format.json { head :no_content }
    end
  end

  def destroy_softly
    @quest = Quest.find(params[:id])
    @quest.relocate_sub_trees
    destroy
  end
  # Get Json for generating tree view
  # @param id [Integer] Quest's id
  # @return [JSON] quest's information in JSON format
  def getTree
    quest = Quest.find(params[:id])
    only_active = true
    if params[:show_all]=='1' then
      only_active =  false
    end
    if (!quest.is_a?(Quest))
      raise 'Expected argument to be a campaign'
    end
    data = quest.to_tree_json(only_active)

    render :text => data.to_json
  end

  # Set quest as user's current active quest
  # @param id [Integer] Quest's id
  def set_active
    @quest = Quest.find(params[:id])
    @user.active_quest_id = @quest.id
    @user.save
    if @quest.status=="On Hold"
      @quest.status="In Progress"
      @quest.save
    end
    create_round(@quest, action_name.capitalize, @quest.campaign)
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
    params.require(:quest).permit(:id, :description, :name, :parent_id, :campaign_id, :group_id, :status, :importance, :deadline, :tag_list, :show_all)
  end


end
