class CampaignsController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::QuestModule

  def indexcd
    @campaigns = Campaign.where('campaign_id IS NULL or campaign_id = ""', :user_id =>  current_user.id)
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new()
  end

  def getTree
    campaign = Campaign.find(params[:id])
    render :text => generateCampaignTree(campaign)
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully started.', location: campaigns_path(@campaign) }
        format.json { render action: 'show', status: :created, location: @campaign }
      else
        format.html { render action: 'new'}
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def campaign_params
    params.require(:campaign).permit(:description, :name)
  end
end