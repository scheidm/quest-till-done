class Pomodoro < ActiveRecord::Base
  has_many :tags
  has_many :nodes
  has_many :notes

  def close
    self.end_time = Time.now
    save
  end

end
