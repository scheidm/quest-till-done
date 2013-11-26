class Record < ActiveRecord::Base
  acts_as :node
  acts_as_superclass
end
