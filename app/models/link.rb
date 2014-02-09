class Link < Record
  has_many :quotes, dependent: :destroy
end
