#Image model for a record
class Image < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
end