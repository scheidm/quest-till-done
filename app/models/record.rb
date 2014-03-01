# Record base model for Link, Note and Image
class Record < ActiveRecord::Base

  attr_accessor :encounter, :quest
  # Record belongs to a quest
  belongs_to :quest
  # Record belongs to a encounter
  belongs_to :encounter
  # Record belongs to a user
  belongs_to :user

  validates_associated :encounter

  # Define scope for Single Table Inheritance
  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}

  def assign_encounter
    self.encounter_id = Encounter.last.id
    self.save
  end

end
