class Pomodoro < ActiveRecord::Base
  attr_accessor :end_time
  has_many :tags
  has_many :nodes
  has_many :notes
  belongs_to: user

  def close
    self.end_time=Time.now if self.end_time.nil?
  end

end
