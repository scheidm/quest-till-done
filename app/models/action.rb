class Action < ActiveRecord::Base
  has_many :records, through: :encounters

end
