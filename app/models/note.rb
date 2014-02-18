# Note model for a record
class Note < Record
  # Validate presence of description, disallow null
  validates_presence_of :description, :allow_blank => false
  validates url, abscence: true
  validates quote, abscence: true
end
