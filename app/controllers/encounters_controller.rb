class EncountersController < ApplicationController

  require 'json_Generator'
  include JsonGenerator::EncounterModule

  # Show all of user's campaigns
  # @return [Html] the index page for all encounter
  def index
    @encounters = Encounter.all
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

  # Show the current state of an encounter
  # @param id [Integer] Encounter's id
  # @return [JSON] the encounter state in JSON
  def getState
    @button = params[:button]
    if params[:button] == 'Start'
      if(Encounter.last.nil? || !Encounter.last.end_time.nil?)
        @encounter = Encounter.create
      else
        @encounter = Encounter.last
      end

      diff = (@encounter.created_at.utc + QuestTillDone::Application.config.encounter_length.seconds - Time.now.utc).to_i
      if( diff > 0)
        @timeRemaining = diff
        start
      else
        @timeRemaining = 0
        @encounter.close
        stop
      end
      @button = 'Stop'
    elsif params[:button] == 'Stop'
      Encounter.last.close if !Encounter.last.nil?
      stop
      @timeRemaining = 0
      @button = 'Start'
    else
      if session[:state] == 'Running'
        @encounter = Encounter.last
        diff = (@encounter.created_at.utc + QuestTillDone::Application.config.encounter_length.seconds - Time.now.utc).to_i
        if( diff > 0)
          @timeRemaining = diff
          start
          @button = 'Stop'
        else
          @timeRemaining = 0
          @encounter.close
          stop
          @button = 'Start'
        end
      else
        @button = 'Start'
      end
    end

    @timeRemaining = 0 if @timeRemaining.nil? || @timeRemaining < 0
    #@button = (!session[:state].nil? || session[:state] == 'Running') ? 'Stop' : 'Start'

    @data = { button: @button, duration: @timeRemaining}
    render :text => @data.to_json
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  # Show the tree view data of an encounter
  # @param id [Integer] Encounter's id
  # @return [JSON] the encounter's tree data in JSON format
  def getTree
    #@pomos = Encounter.all
    #data = [];
    #
    #@pomos.each {|item|
    #  _endTime = item.end_time
    #  _endTime = (item.end_time.nil? ) ? 'Now' : item.end_time.to_formatted_s(:long)
    #  @TreeData = ({:data => item.created_at.to_formatted_s(:long) + ' - ' + _endTime, :attr => { :href => '/encounters/' + item.id.to_s, :rel => 'encounter' }})
    #  @TreeData[:children] = children = []
    #  item.records.each {|record|
    #    type = record.specific
    #    children <<  ({:data => type.class.name, :attr => { :href => '/'+ type.class.name.downcase + 's/' + type.id.to_s, :rel => type.class.name }})
    #  }
    #  data.push(@TreeData)
    #}


    #render :text => @user.to_json(:include => {:tasks => {}})
    render :text => generateTree
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
