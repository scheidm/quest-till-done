##
#===A note on searching
#While handled by solr, below is the details of how to operate Quest.search
#Using solr, define full text search for quests and their records
#@param full_text [String] the text to be found, 'Ruby on Rails', #'documentation'
#@param :estimated_cost
class Quest < ActiveRecord::Base
  searchkick
  acts_as_taggable
  acts_as_taggable_on :skills
  has_many :records
  has_many :links
  has_many :notes
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
  #after_create :set_campaign

  #searchable do
    #text :name, :description
    #text :status
    #integer :estimated_cost, :current_cost, :parent__id, :campaign_id
    #time :updated_at,:created_at
    #text :records do
      #records.map{ |r| r.description }
    #end
    #text :records do
      #records.map{ |r| r.description }
    #end
    #text :links do
      #links.map{ |l| l.url }
    #end
    #text :notes do
      #notes.map{ |n| n.description }
    #end
  #end

  protected
  # Set campaign id after creation
  # If the campaign id is nil, it means it is a campaign but not a quest
  # In that case, set campaign id to its own id
  #def set_campaign
     #if(self.campaign_id.nil?)
       #self.reload
       #self.campaign_id = self.id
       #self.save
     #end
  #end
end
