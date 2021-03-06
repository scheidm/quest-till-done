class Record < ActiveRecord::Base

  has_attached_file :code,
                    :path => ":rails_root/uploads/:class/:id/:basename.:extension",
                    :url => "/records/:id/download"



  validates_attachment_content_type :code, :content_type => ["image/jpg", "image/jpeg", "image/png", "application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf"]

  searchkick
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessor :encounter, :quest, :questname
  # Record belongs to a quest
  belongs_to :quest, touch: true
  # Record belongs to a encounter
  belongs_to :encounter
  # Record belongs to a user
  belongs_to :group
  delegate :user, to: :encounter
  before_destroy :destroy_rounds
  after_save :touch_quest

  validates_associated :encounter

  # Define scope for Single Table Inheritance
  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}

  
  def touch_quest
    if(self.quest.status=="Open") then
      self.quest.status="In Progress"
      self.quest.save
    end
  end

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
