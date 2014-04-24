class Commit < Record
  validates_presence_of :description, :url, :allow_blank => false
  belongs_to :quest
end
