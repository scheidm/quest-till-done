#A record that represents a file uploaded by the user. The path field stores the
#location of the file on the server to allow retrieval
class Image < Record
  # Validate presence of description and url


  validates_attachment_presence :code
  def destroy_rounds
    Round.where( type: "Image").where(event_id: self.id).destroy_all
  end


end
