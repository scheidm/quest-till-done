class Timer < ActiveRecord::Base
  belongs_to :user
  before_create :init

  def init
    self.current_time ||= 1800
    self.setting_time ||= 1800
    self.enabled ||= true
  end
end
