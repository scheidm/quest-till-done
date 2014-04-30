# Controller for Record
class RecordsController < ApplicationController

  require 'json_generator'
  include JsonGenerator::QuestModule
  include RoundHelper
  include GithubHelper

  # Show all records belongs to a user
  # @return [Html] All records belong to a user
  def index
    @records = Record.all
  end

  # Show record detail
  # @param id [Integer] record id
  # @return [Html] Record detail page with the id
  def show
    @record = Record.find(params[:id])
  end

  # Create new record for a quest
  # @param id [Integer] Record id
  # @return [Html] New record creation page
  def new
    @record = Record.new()
    @record.quest_id = params[:quest_id]
    @record.quest = Quest.find(params[:quest_id])
  end

  # Save new record
  # @param record_params[record_params] field input from creation page
  # @return [Html] redirect back to records index page
  def create
    @record = Record.new(record_params)
    @record.quest = Quest.find(@record.quest_id)
    @record.created_at = DateTime.now
    @record.group_id = @user.wrapper_group.id
    @record.assign_encounter @user
    if @record.save
      create_round(@record, action_name, @record.quest.get_campaign)
      success=true
    else
      success=false
    end

    respond_to do |format|
      if success
        format.html { redirect_to :back , notice: "#{@record.type} \"#{@record.description.to_s[0..30].gsub(/\s\w+$/,'...')}\"  was successfully created."}
      else
        format.html { redirect_to :back, notice: "Error! #{@record.type} not created! Error: #{@record.errors.inspect}" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end

    end

    @quest = Quest.find(@record.quest_id)
    unless @quest.issue_no.nil?
      accounts = GithubRepo.where(campaign_id: @quest.campaign_id).first
      push_comment(accounts.github_user, accounts.project_name, @quest.issue_no, @record.description)
    end
  end

  # Delete record
  # @param id [Integer] record id
  # @return [Html] redirect back to record index page
  def destroy


    @record= Record.find(params[:id]).destroy

    flash[:notice] = "#{@record.type} \"#{@record.description.to_s[0..30].gsub(/\s\w+$/,'...')}\" was successfully deleted."
    redirect_to(:back)

  end

  # Edit record
  # @param id [Integer] record id
  # @return [Html] redirect back to record index page
  def edit
    @record= Record.find(params[:id])
  end

  # Define allowed parameter for a record model
  # @param description [String] Record's description
  # @param encounter_id [Integer] Record's encounter_id
  # @param encounter [Encounter] Record's encounter
  def record_params
    params.require(:record).permit(:description, :encounter_id, :encounter, :quest_id, :type, :url, :code, :id)
  end

  def quest_autocomplete
    render json:  Quest.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def download
    @record = Record.find(params[:id])
    send_file @record.code.path, :type => @record.code_content_type, :disposition => 'inline'
  end


end
