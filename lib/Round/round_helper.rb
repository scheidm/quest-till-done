module RoundHelper

  require 'timer/timer_helper'
  include TimerHelper

  def createRound(model, operation, campaign)
    if(!getState)
      startTimer
    end
    Round.createEvent(model, operation, campaign)
  end

end