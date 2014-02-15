class Encounter < ActiveRecord::Base
  has_many :records
  has_many :notes
  belongs_to :user

  def close
    self.end_time = Time.now if self.end_time.nil?
    save
  end

end
