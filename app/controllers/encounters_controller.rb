class EncountersController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::EncounterModule

  # Show all of user's campaigns
  # @return [Html] the index page for all encounter
  def index
  end

  def get_user_timeline
    @encounters = Encounter.where(:user_id => current_user.id)
    render :text => generateTree(@encounters)
  end

  # Create new encounter
  # @return [Html] New encounter page
  def new
    @encounter = Encounter.new
  end

  # Show the detail of an encounter
  # @param id [Integer] Encounter's id
  # @return [Html] the encounter detail with that id
  def show
    @encounter = Encounter.find(params[:id])
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # Show the tree view data of an encounter
  # @param id [Integer] Encounter's id
  # @return [JSON] the encounter's tree data in JSON format
  def getTree
    #render :text => generateTree
  end

  # Start an encounter
  # @param id [Integer] Encounter's id
  private
  def start
    session[:state] = 'Running'
    session[:encounter_id] = @encounter.id
  end

  # Stop an encounter
  # @param id [Integer] Encounter's id
  def stop
    session[:state] = 'Stopped'
    session[:encounter_id] = nil
  end
end
