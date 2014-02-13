class Record < ActiveRecord::Base
  attr_accessor :encounter
  belongs_to :quest
  belongs_to :encounter
  validates_associated :encounter

  scope :link, ->{where(type: "Link")}
  scope :note, ->{where(type: "Note")}
end
