# A specific, actionable task to complete in given project.
# Shares a table through STI with Campaign
class Quest < ActiveRecord::Base
  include RoundHelper
  searchkick

  scope :search_import, -> { includes(:records) }
  acts_as_taggable
  acts_as_taggable_on :skills
  has_many :records, dependent: :destroy
  has_many :rounds
  has_many :links
  has_many :notes
  has_many :images
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
  before_destroy :delete_related

  def search_data
    attributes.merge(
      records: self.records.map(&:description),
      notes: self.notes.map(&:description),
      quotes: self.links.map(&:quote),
      sites: self.links.map(&:url),
      tags: self.tags.map(&:name)
    )
  end

  def delete_related
    campaign=self.campaign
    quest = Quest.new({name: self.name})
    Round.where( type: "Quest").where(event_id: self.id).destroy_all
    Round.create_event(quest, "destroy", campaign)
    self.child_quests.each do |cq|
      cq.destroy
    end
  end

  def relocate_sub_trees
    self.child_quests.each do |cq|
      cq.parent=self.parent
      cq.save
    end
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

  def toggle_state
    if self.status =='Closed' then
      if self.records.count > 0 then
        self.status="In Progress" 
      else 
        self.status="Open" 
      end
      action="Re-opened"
    else
      self.status="Closed" 
      action="Closed" 
    end
    self.save
    return action;
  end 
end
