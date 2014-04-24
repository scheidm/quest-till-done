# Timer class for a timer configuration on a per user basis
class Timer < ActiveRecord::Base
  # Timer belongs to a user
  belongs_to :user
  # Initialize default value before creation
  before_create :init

  # Will set default value for each value in the setting table
  def init
    self.current_time ||= 1800
    self.setting_time ||= 1800
    self.enabled ||= true
    self.state ||= false
    self.mode ||= 'auto'
  end

  #Will set the current state of the timer
  def set_state(state)
    self.state = state
    self.save
  end

  #Will return the current state of the timer
  def get_state
    return self.state == 't' || self.state == true
  end
end
