# Record base model for Link, Note and Image
class Record < ActiveRecord::Base


  searchkick
  acts_as_taggable
  acts_as_taggable_on :skills
  extend FriendlyId
  friendly_id :description, use: [:slugged, :history]
  attr_accessor :encounter, :quest, :questname
  # Record belongs to a quest
  belongs_to :quest
  # Record belongs to a encounter
  belongs_to :encounter
  # Record belongs to a user
  belongs_to :group
  delegate :user, to: :encounter

  validates_associated :encounter

  # Define scope for Single Table Inheritance
  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}

  def assign_encounter( user )
    self.encounter_id = Encounter.where(:user_id => user.id).last.id
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


  def normalize_friendly_id(string)
    super[0..139]
  end

  def to_link
    self.quest.to_link
  end

end
