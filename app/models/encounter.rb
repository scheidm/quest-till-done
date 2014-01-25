class Encounter < ActiveRecord::Base
  has_many :tags
  has_many :records
  has_many :notes

  def close
    self.end_time = Time.now if self.end_time.nil?
    save
  end

end
