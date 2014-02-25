# Encounter model
class Encounter < ActiveRecord::Base
  # Encounter has many tags
  has_many :tags
  # Encounter has many records
  has_many :records
  has_many :rounds
  # Encounter belongs to a user
  belongs_to :user

  # Set the end time for the encounter when called
  def close
    self.end_time = Time.now if self.end_time.nil?
    save
    self.class.clean(self.user_id)
  end

  # Clean empty encounter
  def self.clean(user_id)
    encounters = Encounter.where(:user_id => user_id)
    encounters.each do |encounter|
      if(encounter.rounds.size == 0 && encounter.records.size == 0)
         encounter.destroy
      end
    end
  end

end
