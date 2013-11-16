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
    @state = (session[:state].nil?) ? 'Start' : session[:state]
    render :text => @state
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
      item.notes.each {|item|
        children <<  ({:data => item.description, :attr => { :href => '/notes/' + item.id.to_s, :rel => 'note' }})
      }
      data.push(@TreeData)
    }

    #render :text => @user.to_json(:include => {:tasks => {}})
    render :text => data.to_json
  end
end
