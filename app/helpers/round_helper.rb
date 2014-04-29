module RoundHelper
  include TimerHelper

  #Will create a round linking the specified model, campaign, and recording the
  #operation the round represents
  #@param model [ActiveRecord::Base] A rails object reference by the activity
  #@param campaign [Campaign] The campaign the round is related to
  #@param operation [String] The controller action performed on the model
  def create_round(model, operation, campaign)
    if(!get_timer_state)
      start_timer
    end
    Round.create_event(model, operation, campaign)
  end

end
