module RoundHelper

  include TimerHelper

  def create_round(model, operation, campaign, user)
    if(!get_timer_state)
      start_timer
    end
    Round.create_event(model, operation, campaign, user)
  end

end
