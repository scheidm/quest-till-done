# Encounter model
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

  # Set the end time for the encounter when called
  def close
    self.end_time = Time.now if self.end_time.nil?
    save
  end

  def before_save
    @is_new_record = new_record?
    return true
  end
  # Clean empty encounter
  def clean
    if(@is_new_record == false && self.rounds.size == 0 && self.records.size == 0)
      destroy
    end
  end

end
