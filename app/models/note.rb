class Note < ActiveRecord::Base
  acts_as :node
  validates_presence_of :description, :allow_blank => false
end
