# Record base model for Link, Note and Image
class Record < ActiveRecord::Base

  searchkick
  attr_accessor :encounter, :quest, :questname
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
  
  def to_s
    "#{self.description} ( for the Quest #{self.quest.to_s} )"
  end

  @child_classes = []

  def self.inherited(child)
    @child_classes << child
    super # important!
  end

  def self.child_classes
    @child_classes
  end



  def to_link
    self.quest.to_link
  end

end
