#A record that represents a file uploaded by the user. The path field stores the
#location of the file on the server to allow retrieval
class Image < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
  # has_attached_file :code,
  #                   :path => ":rails_root/uploads/:class/:id/:basename.:extension",
  #                   :url => "/sources/:id/download"
  #
  # validates_attachment_presence :code
  # validates_attachment_content_type :code, :content_type => ["image/jpg", "image/jpeg", "image/png", "application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf"]


end
