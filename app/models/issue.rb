class Issue < Record
  has_many :quotes, dependent: :destroy
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false

  def self.model_name
    Record.model_name
  end
end