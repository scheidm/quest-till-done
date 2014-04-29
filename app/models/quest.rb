# A specific, actionable task to complete in given project.
# Shares a table through STI with Campaign
class Quest < ActiveRecord::Base

  searchkick
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

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
  has_many :child_quests, :class_name => 'Quest', :foreign_key => 'parent_id'
  # Belongs to a user/owner
  belongs_to :group
  before_save :set_status

  
  #Will define additional relational data for the purpose of deep searching, as
  #specified through the searchkick gem
  def search_data
    attributes.merge(
      records: self.records.map(&:description),
      notes: self.notes.map(&:description),
      quotes: self.links.map(&:quote),
      sites: self.links.map(&:url)
    )
  end

  #Will report whether this quest is also a campaign
  def campaign?
    self.type=="Campaign"
  end

  #Will report whether this quest is also a campaign
  def get_campaign
    return self.campaign || self
  end

  #Will generate a list of campaigns related to quests found for the given query
  def self.meta_search query
    quests=Quest.search(query).results.map(&:campaign_id)
    Campaign.where('id in (?)',quests)
  end

  def to_s
    self.name
  end

  #Will define the link generated in the timeline when interacting with this
  #model.
  def to_link
    '/quests/' + self.id.to_s
  end

  #Will ensure that a new quest has a status
  def set_status
    self.status = 'Open' if self.status.nil?
  end


  #Will report whether the provided quest is an ancestor of the current quest
  #@param quest [Quest] 
  def is_ancestor(quest)
    if(quest.parent != nil)
      if(self == quest.parent)
        return true
      else
        is_ancestor(quest.parent)
      end
    end
    return false
  end

  def descendants
    children = []
    self.child_quests.each do |cq|
      children.concat cq.descendants
      children.push cq
    end
    return children
  end


end

  #Will recursively generate a list of all a quests descendants through their
  #direct children and their children's children.
  #@return [ActiveRecord::Relation] list of descendants
  def descendants
    children = []
    self.child_quests.each do |cq|
        children.concat cq.descendants
        children.push cq
      end
    return children
  end
