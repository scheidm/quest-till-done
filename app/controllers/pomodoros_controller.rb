class PomodorosController < ApplicationController
  def index
    @pomos = Pomodoro.all
  end

  def new
    @pomo = Pomodoro.new
  end

  def show
  end

  def getTree
    @pomos = Pomodoro.all
    data = [];

    @pomos.each {|item|
      @TreeData = ({:data => 'pomodoro ' + item.id.to_s, :attr => { :href => '/pomodoros/' + item.id.to_s }})
      #@TreeData[:children] = children = []
      #item.nodes.each {|item|
      #  children <<  ({:data => item.id, :attr => { :href => '/nodes/' + item.id.to_s }})
      #}
      data.push(@TreeData)
    }

    #render :text => @user.to_json(:include => {:tasks => {}})
    render :text => data.to_json
  end
end
