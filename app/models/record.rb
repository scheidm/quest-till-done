# Record base model for Link, Note and Image
class Record < ActiveRecord::Base
  attr_accessor :encounter
  # Record belongs to a quest
  belongs_to :quest
  # Record belongs to a encounter
  belongs_to :encounter
  # Validate the association is present
  validates_associated :encounter

  # Define scope for Single Table Inheritance
  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}
end
