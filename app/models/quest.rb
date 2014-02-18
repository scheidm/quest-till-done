# Quest model for a task
class Quest < ActiveRecord::Base
  # Has many different types of records
  has_many :records
  # Belongs to a campaign
  belongs_to :campaign, :class_name => 'Quest'
  # Has many quests underneath this quest's subtree
  has_many :all_quests, :class_name => 'Quest', :foreign_key => 'campaign_id'
  # Belongs to a immediate parent quest
  belongs_to :parent, :class_name => 'Quest'
  # A quest could have many immediate children quest
  has_many :quests, :foreign_key => 'parent_id'
  # Belongs to a user/owner
  belongs_to :user
  # Set campaign id after creation
  after_create :set_campaign

  protected
  # Set campaign id after creation
  # If the campaign id is nil, it means it is a campaign but not a quest
  # In that case, set campaign id to its own id
  def set_campaign
     if(self.campaign_id.nil?)
       self.reload
       self.campaign_id = self.id
       self.save
     end
  end
end
