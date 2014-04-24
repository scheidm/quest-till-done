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
  before_save :before_save
  after_save :clean

  # Set the end time for the encounter when called, using the current time on
  # the server as the end point
  def close
    self.end_time = Time.now.utc if self.end_time.nil?
    save
  end

  def before_save
    @is_new_record = new_record?
    self.break_flag ||= false
    return true
  end
  # Clean empty encounter
  def clean
    if(@is_new_record == false && self.rounds.size == 0 && self.records.size == 0)
      destroy
    end
  end

end
