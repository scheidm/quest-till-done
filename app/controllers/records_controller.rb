# Controller for Record
class RecordsController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::QuestModule
  include RoundHelper

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
  end

  # Save new record
  # @param record_params[record_params] field input from creation page
  # @return [Html] redirect back to records index page
  def create
    @record = Record.new(record_params)
    @encounter = Encounter.last
    @encounter = Encounter.create if @encounter.nil? || @encounter.created_at<30.minutes.ago
    @record.encounter_id = @encounter.id
    @record.created_at = DateTime.now
    @user = User.find(current_user.id)
    @record.quest=@user.active_quest


    respond_to do |format|
      if @record.save
        create_round(@record, action_name, current_user.active_quest.campaign)
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @record }
      else
        format.html { render action: 'new'}
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete record
  # @param id [Integer] record id
  # @return [Html] redirect back to record index page
  def destroy
    @record= Record.find { params[:id]}.destroy
  end

  # Define allowed parameter for a record model
  # @param description [String] Record's description
  # @param encounter_id [Integer] Record's encounter_id
  # @param encounter [Encounter] Record's encounter
  def record_params
    params.require(:record).permit(:description, :encounter_id, :encounter, :quest_id, :record_type)
  end
end
