#A record that represents a file uploaded by the user. The path field stores the
#location of the file on the server to allow retrieval
class Image < Record
  validates :url, absence: true
  validates :quote, absence: true
  belongs_to :quest
  # Validate presence of description and url
  def url
    return self.code.url
  end
  validates_attachment_presence :code
  def destroy_rounds
    Round.where( type: "Image").where(event_id: self.id).destroy_all
  end


end
