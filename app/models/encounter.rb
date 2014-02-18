# Encounter model
class Encounter < ActiveRecord::Base
  # Encounter has many tags
  has_many :tags
  # Encounter has many records
  has_many :records
  # Encounter belongs to a user
  belongs_to :user

  # Set the end time for the encounter when called
  def close
    self.end_time = Time.now if self.end_time.nil?
    save
  end

end
