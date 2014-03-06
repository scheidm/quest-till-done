# A record that represents a web reference, the path field holding the url of
# the website in question
class Link < Record
  has_many :quotes, dependent: :destroy
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false

  belongs_to :quest

  def self.model_name
    Record.model_name
  end
end
