class PomodorosController < ApplicationController
  def index
    @pomos = Pomodoro.all
  end

  def new
    @pomodoro = Pomodoro.new
  end

  def show
    @pomodoro = Pomodoro.find(params[:id])
  end

  def setState
    @state = params[:state]
    @pomodoro = Pomodoro.last
    if params[:state] == 'Start'
      @pomodoro = Pomodoro.create if @pomodoro.nil? || @pomodoro.created_at<30.minutes.ago || !@pomodoro.end_time.nil?
      session[:pomodoro_id] = @pomodoro.id
    end
    else if params[:state] == 'Stop'
      Pomodoro.last.close
      session[:pomodoro_id] = nil
    end
    session[:state] = (@state.casecmp('Start') == 0) ? 'Stop' : 'Start'
    #render :text => session[:state]
    redirect_to :back
  end

  def getState
    @button = params[:button]
    if params[:button] == 'Start'
      if(Pomodoro.last.nil? || !Pomodoro.last.end_time.nil?)
        @pomodoro = Pomodoro.create
      else
        @pomodoro = Pomodoro.last
      end

      diff = (@pomodoro.created_at.utc + 10.seconds - Time.now.utc).to_i
      if( diff > 0)
        @timeRemaining = diff
        start
      else
        @timeRemaining = 0
        @pomodoro.close
        stop
      end
      @button = 'Stop'
    elsif params[:button] == 'Stop'
      Pomodoro.last.close if !Pomodoro.last.nil?
      stop
      @timeRemaining = 0
      @button = 'Start'
    else
      if session[:state] == 'Running'
        @pomodoro = Pomodoro.last
        diff = (@pomodoro.created_at.utc + 10.seconds - Time.now.utc).to_i
        if( diff > 0)
          @timeRemaining = diff
          start
          @button = 'Stop'
        else
          @timeRemaining = 0
          @pomodoro.close
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

  def getTree

    @pomos = Pomodoro.all
    data = [];

    @pomos.each {|item|
      _endTime = item.end_time
      _endTime = (item.end_time.nil? ) ? 'Now' : item.end_time.to_formatted_s(:long)
      @TreeData = ({:data => item.created_at.to_formatted_s(:long) + ' - ' + _endTime, :attr => { :href => '/pomodoros/' + item.id.to_s, :rel => 'pomodoro' }})
      @TreeData[:children] = children = []
      item.nodes.each {|node|
        type = node.specific
        children <<  ({:data => type.class.name, :attr => { :href => '/'+ type.class.name.downcase + 's/' + type.id.to_s, :rel => type.class.name }})
      }
      data.push(@TreeData)
    }

    #render :text => @user.to_json(:include => {:tasks => {}})
    render :text => data.to_json
  end

  private
  def start
    session[:state] = 'Running'
    session[:pomodoro_id] = @pomodoro.id
  end

  def stop
    session[:state] = 'Stopped'
    session[:pomodoro_id] = nil
  end
end
