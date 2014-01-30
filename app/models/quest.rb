class Quest < ActiveRecord::Base
  belongs_to :campaign, :class_name => 'Quest'
  has_many :all_quests, :class_name => 'Quest', :foreign_key => 'campaign_id'
  belongs_to :parent, :class_name => 'Quest'
  has_many :quests, :foreign_key => 'parent_id'
  belongs_to :user
end
