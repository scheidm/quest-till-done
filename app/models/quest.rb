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



  def search_data
    attributes.merge(
      records: self.records.map(&:description),
      notes: self.notes.map(&:description),
      quotes: self.links.map(&:quote),
      sites: self.links.map(&:url)
    )
  end

  def campaign?
    self.type=="Campaign"
  end

  def get_campaign
    return self.campaign || self
  end

  def self.meta_search query
    quests=Quest.search(query).results.map(&:campaign_id)
    Campaign.where('id in (?)',quests)
  end

  def to_s
    self.name
  end

  def to_link
    '/quests/' + self.id.to_s
  end

  def set_status
    self.status = 'Open' if self.status.nil?
  end

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
