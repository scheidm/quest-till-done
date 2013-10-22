class Pomodoro < ActiveRecord::Base
  attr_accessor :end_time
  has_many :tags
  has_many :nodes

  def close
    self.end_time=Time.now if self.end_time.nil?
  end

end
