# A specific, actionable task to complete in given project.
# Shares a table through STI with Campaign
class Quest < ActiveRecord::Base
  include RoundHelper
  include GithubHelper
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
  before_save :cleanup
  before_destroy :delete_related
  
  def status_class
    stati={ "Open"     => "Open",
            "Closed"   => "Closed",
            "On Hold"  => "OnHold",
            "Archived" => "Archived",
            "Active" => "InProgress",
            "In Progress" =>"InProgress"
    }
    return stati[self.status]
  end

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

  def to_json
    return {:id   => self.id, 
            :attr => { 
                     :name        =>  self.name, 
                     :description =>  self.description || "",
                     :url         =>  "/#{self.class.name.downcase.pluralize}/" +  self.id.to_s, 
                     :status      =>  self.status,
                     :record_count=>  self.records.count
                     }
            }
  end 
  
  
  def to_tree_json(only_active)
    if(self.description) then
      desc= ApplicationController.helpers.trunc(self.description, 100)
    else
      desc=''
    end
    data = self.to_json
    if(self.child_quests.size == 0)
       return data
    else
      data[:children] = children = []
      self.child_quests.each {|q|
        children << q.to_tree_json(only_active) unless only_active&&q.status=="Closed"
      }
    end
    return data
  end

  def to_link
    '/quests/' + self.id.to_s
  end

  def cleanup
    self.status = 'Open' if self.status.nil?
    self.description = nil if self.description==""
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

  def toggle_state(user)
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
    self.update_cleanup(user)
    return action;
  end 

  def update_cleanup(user)
    if self.status =='Closed' then
      if self.campaign.vcs then #sync with github
        github_info = GithubRepo.where(campaign_id: self.campaign.id).first
        close_issue(@user, github_info.github_user, github_info.project_name, self.issue_no)
      end
      if self.id==user.active_quest.id then
        user.set_default_active_quest
      end
    end
  end
  def delete_cleanup(user)
    if self.id==user.active_quest.id then
      user.set_default_active_quest
    end
  end
end
