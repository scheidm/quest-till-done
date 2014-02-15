class Quest < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :skills
  has_many :records
  belongs_to :campaign, :class_name => 'Quest'
  has_many :all_quests, :class_name => 'Quest', :foreign_key => 'campaign_id'
  belongs_to :parent, :class_name => 'Quest'
  has_many :quests, :foreign_key => 'parent_id'
  belongs_to :user
  after_create :set_campaign

  protected
  def set_campaign
     if(self.campaign_id.nil?)
       self.reload
       self.campaign_id = self.id
       self.save
     end
  end
end
