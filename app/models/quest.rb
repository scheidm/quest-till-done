##
#===A note on searching
#While handled by solr, below is the details of how to operate Quest.search
#Using solr, define full text search for quests and their records
#@param full_text [String] the text to be found, 'Ruby on Rails', #'documentation'
#@param :estimated_cost
class Quest < ActiveRecord::Base
  searchkick
  scope :search_import, -> { includes(:records) }
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

  def search_data
    attributes.merge(
      note_desc: notes.map(&:description)
    )
  end

  def campaign?
    self.campaign_id.nil?
  end

  def get_campaign
    return self.campaign || self
  end

  def to_s
    self.name
  end

end
