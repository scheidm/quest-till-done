# A record that will represent a web reference. The path field will hold the url of
# the website in question
class Link < Record
  # has_many :quotes, dependent: :destroy
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false

  belongs_to :quest
end
