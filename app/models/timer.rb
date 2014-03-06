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
  end
end
