class Record < ActiveRecord::Base
  attr_accessor :encounter, :quest, :record_type
  belongs_to :quest
  belongs_to :encounter
  belongs_to :user
  validates_associated :encounter

  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}

  def after_create()
      quest_id = quest.active_quest
  end

end
