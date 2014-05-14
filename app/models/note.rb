# A record that contains a simple text note
class Note < Record
  # Validate presence of description, disallow null
  validates_presence_of :description, :allow_blank => false
  validates :url, absence: true
  validates :quote, absence: true

  belongs_to :quest
  def destroy_rounds
    Round.where( type: "Note").where(event_id: self.id).destroy_all
  end
end
