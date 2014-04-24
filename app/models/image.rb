#A record that will represent a file uploaded by the user. The path field will store the
#location of the file on the server to allow retrieval
class Image < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
end
