# The Encounter model is the central reference point for all activity within a
# given time block, as a tool for displaying timeline information, as well as
# for chunking the work-day into discreet units.
class Encounter < ActiveRecord::Base
  # Encounter has many tags
  has_many :tags
  # Encounter has many records
  has_many :records
  has_many :rounds
  # Encounter belongs to a user
  belongs_to :user

  # Set the end time for the encounter when called, using the current time on
  # the server as the end point
  def close
    self.end_time = Time.now if self.end_time.nil?
    save
  end

end
