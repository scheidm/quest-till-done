# Record base model for Link, Note and Image
class Record < ActiveRecord::Base

  attr_accessor :encounter, :quest, :record_type
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

  def after_create()
      quest_id = quest.active_quest
  end

end
