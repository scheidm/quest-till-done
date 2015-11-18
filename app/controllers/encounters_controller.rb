class EncountersController < ApplicationController

  # Show all of user's campaigns
  # @return [Html] the index page for all encounter
  def index
    #data generated on js side by calling the controller method
    #get_user_timeline
  end

  def get_user_timeline
    encounters = Encounter.where(:user_id => @user.id).order(created_at: :desc)
    data = []
    data_by_date = {}
    count=0
    encounters.each do |encounter|
      break unless count<=100
      encounter_data=encounter.to_json
      count+=encounter_data.count
      data_by_date[encounter.created_at.to_date] ||= Array.new
      if encounter_data[:children].size > 0
        data_by_date[encounter.created_at.to_date].push(encounter_data)
      end
    end
    data_by_date.each do |key, value|
      temp = {:data => key, :attr => { :rel => 'encounter', :href => 'javascript:void(0)'}}
      temp[:children] = value
      data.push(temp)
    end
    render :text => data.to_json
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
