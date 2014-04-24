class EncountersController < ApplicationController

  require 'json_generator'
  include JsonGenerator::EncounterModule

  # Will show a timeline generated from a user's encounters
  # @return [Html] the index page for all encounter
  def index
    #data generated on js side by calling the controller method
    #get_user_timeline
  end

  # Will gather the data and render the timeline for the user
  def get_user_timeline
    @encounters = Encounter.where(:user_id => @user.id)
    render :text => generateTree(@encounters, nil)
  end

  # Will create a new encounter
  # @return [Html] New encounter page
  def new
    @encounter = Encounter.new
  end

  # Will show the details of an encounter
  # @param id [Integer] Encounter's id
  # @return [Html] the encounter detail with that id
  def show
    @encounter = Encounter.find(params[:id])
  end

  # Will forcibly raise an "object not found" error
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # Will show the tree view data of an encounter
  # @param id [Integer] Encounter's id
  # @return [JSON] the encounter's tree data in JSON format
  def getTree
    #render :text => generateTree
  end

  private

  # Will start a new encounter for the user
  # @param id [Integer] Encounter's id
  def start
    session[:state] = 'Running'
    session[:encounter_id] = @encounter.id
  end

  # Will stop an encounter and clear the currently active encounter from the
  # user's session
  # @param id [Integer] Encounter's id
  def stop
    session[:state] = 'Stopped'
    session[:encounter_id] = nil
  end
end
