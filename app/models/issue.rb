class Issue < Quest
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false

  def self.model_name
    Quest.model_name
  end
end