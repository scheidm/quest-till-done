# Controller for Campaign
class CampaignsController < ApplicationController
  power :crud => :campaigns

  include RoundHelper
  include ApplicationHelper 

  helper_method :campaign_timeline_path

  # Show all of user's campaigns
  # @return [Html] the index page for all campaign
  def index
    @archive = @user.campaigns.where(:status => "Archived")
    @campaigns = @user.total_campaigns.order(status: :desc, name: :asc)
    @active=@campaigns.reject{ |c| c.status =~ /Archived/}
  end

  # Show the detail of a campaign
  # @param id [Integer] Campaign's id
  # @return [Html] the campaign detail with that id
  def show
    logger.info params
    @campaign = Campaign.find(params[:id])
    @actionable=@campaign
    #reverse history but direct to new

    if request.path != campaign_path(@campaign)
      redirect_to @campaign, status: :moved_permanently
    end
  end
  # Create new campaign
  # @return [Html] New campaign page
  def new
    @campaign = Campaign.new()
    @campaign.group_id=params[:group_id]||@user.wrapper_group.id
  end

  # Get Json for generating tree view
  # @param id [Integer] Campaign's id
  # @return [JSON] campaign's information in JSON format
  def getTree
    campaign = Campaign.find(params[:id])
    only_active = true
    if params[:show_all]=='1' then
      only_active =  false
    end
    if (!campaign.is_a?(Campaign))
      raise 'Expected argument to be a campaign'
    end
    data = campaign.to_json
    data[:children] = children = []
    campaign.child_quests.each {|quest|
      children << quest.to_tree_json(only_active) unless only_active&&quest.status=="Closed"
    }
    render :text => data.to_json
  end


  # Save new campaign
  # @param campaign_params [campaign_params] field input from creation page
  # @return [Html] redirect back to the new campaign page
  def create
    @campaign = Campaign.new(campaign_params)

    @user.tag_list.add(params[:tag_list])
    respond_to do |format|
      if @campaign.save
        @user.save
        create_round(@campaign, action_name, @campaign)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully started.', location: campaigns_path(@campaign) }
        format.json { render action: 'show', status: :created, location: @campaign }
      else
        format.html { render action: 'new'}
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # Edit existing campaign
  # @param id [Integer] Campaign's id
  # @return [Html] Campaign editing page
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # Update campaign changes and save the changes
  # @param campaign_params [campaign_params] field input from creation page
  # @return [Html] redirect back to campaigns index page
  def update
    @campaign = Campaign.find(params[:id])
    @campaign.tag_list=params[:tag_list]
    @user.tag_list.add(params[:tag_list])
    respond_to do |format|
      if @quest.save
        @user.save
      end
      if @campaign.update(campaign_params)
        create_round(@campaign, action_name, @campaign)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render campaign: 'edit' }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete campaigns and all the quests and records it associated with
  # @param id [Integer] Campaign's id
  # @return [Html] redirect back to campaigns index page
  def destroy
    @campaign = Campaign.find(params[:id])
    create_round(@campaign, action_name, @user.campaigns.where(name: "My Journey").first)
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_path }
      format.json { head :no_content }
    end
  end

  # View timeline
  # @param id [Integer] Campaign'id to be viewed
  # @return [Html] partial view of the timeline
  def timeline
    @campaign = Campaign.find(params[:id])
  end

  # Get the current timeline for the campaign
  # @param campaign [Campaign] Campaign
  # @return [JSON] JSON of the timeline details
  def get_campaign_timeline
    @campaign = Campaign.find(params[:id])
    rounds=@campaign.rounds.limit(100).order("created_at DESC")
    data = []
    rounds.each do |round|
      data << round.to_json
    end
    render :text => data.to_json  
  end

  # Import a QTD specific format Campaign to generate a campaign
  # @param path [String] file path
  def import
    encounter = Encounter.new
    encounter.rounds = Encounter.where(:user_id => @user.id, :campaign_id => params[:id])

  end

  # Export a Campaign to a QTD specific format
  # @param id [Integer] Campaign's id
  # @param type [String] File format to be exported
  # @return [File] downloadable file
  def export

  end

  # Set quest parent through AJAX
  # @param quest_id [Integer] Quest's id of quest to be moved
  # @param parent_id [Integer] Quest's id of quest to be set as parent quest
  def set_quest_parent
    quest = Quest.find(params[:quest_id])
    quest.parent_id = params[:parent_id]
    quest.save
    render :nothing => true
  end

  # custom helper path for timeline
  # @param id [Integer] Campaign
  def campaign_timeline_path(campaign)
    "/campaigns/timeline?id=#{campaign.id}"
  end
  # @param description [String] Campaign's description
  # @param name [String] Campaign's name
  def campaign_params
    params.require(:campaign).permit(:description, :status, :name, :group_id, :id, :show_all)
  end
end
