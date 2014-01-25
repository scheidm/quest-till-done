class Note < ActiveRecord::Base
  validates_presence_of :description, :allow_blank => false
end
