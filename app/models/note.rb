# Note model for a record
class Note < Record
  # Validate presence of description, disallow null
  validates_presence_of :description, :allow_blank => false
  validates :url, absence: true
  validates :quote, absence: true

  def self.model_name
    Record.model_name
  end
end
