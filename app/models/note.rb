class Note < Record
  validates_presence_of :description, :allow_blank => false
end
