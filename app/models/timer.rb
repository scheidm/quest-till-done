# Timer class for a timer configuration on a per user basis
class Timer < ActiveRecord::Base
  # Timer belongs to a user
  belongs_to :user
  # Initialize default value before creation
  before_create :init

  # Set default value for each value in the setting table
  def init
    self.current_time ||= 1800
    self.setting_time ||= 1800
    self.enabled ||= true
    self.state ||= false
    self.mode ||= 'auto'
  end

  # set the current state
  def set_state(state)
    self.state = state
    self.save
  end

  # get the current state
  def get_state
    return self.state == 't' || self.state == true
  end
end
