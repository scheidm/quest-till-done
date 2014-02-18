# Link class for a Record
class Link < Record
  has_many :quotes, dependent: :destroy
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
end
