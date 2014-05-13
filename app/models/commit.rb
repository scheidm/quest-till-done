class Commit < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
  belongs_to :quest
  def destroy_rounds
    Round.where( type: "Commit").where(event_id: self.id).destroy_all
  end
end
