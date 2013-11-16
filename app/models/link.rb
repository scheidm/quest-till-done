class Link < ActiveRecord::Base
  acts_as :record
  has_many :quotes, dependent: :destroy
end
