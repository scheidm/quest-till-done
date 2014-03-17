class Commit < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
  belongs_to :quest

  def self.model_name
    Record.model_name
  end

end