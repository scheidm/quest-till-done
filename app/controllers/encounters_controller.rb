class EncountersController < ApplicationController

  # Show all of user's campaigns
  # @return [Html] the index page for all encounter
  def index
    #data generated on js side by calling the controller method
    #get_user_timeline
  end

  def get_user_timeline
    rounds=@user.rounds.limit(100).order(created_at: :desc)
    encounters = Encounter.where('id in (?)', rounds.pluck(:encounter_id).uniq).order(created_at: :desc)
    data = []
    data_by_date = {}
    jhash={}
    encounters.each do |e|
      jhash[e.id]=e.to_json
      data_by_date[e.created_at.to_date] ||= Array.new
      data_by_date[e.created_at.to_date].push( jhash[e.id] )
    end
    rounds.each do |r|
      jhash[r.encounter_id][:children].push(r.to_json)
      jhash[r.encounter_id][:count]+=1
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
