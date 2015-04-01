# timelines
class Group < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns, dependent: :destroy
  has_many :quests
  has_many :rounds, dependent: :destroy
  has_many :github_repos, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :admins, class_name: "User", join_table: "admins_groups"
  # Leave the group while preventing orphan groups. If the user is the last
  # admin, the function will automatically promote the oldest member to group
  # admin before leaving. If the user is the last member in the group, the
  # function will delete the group and associated campaigns from the database
  def leave user
    demote user
    self.users.destroy user
    if self.users.size == 0
      self.destroy
    end
  end

  def demote user
    if self.admins.include? user
      #multi-user group, promote new admin
      if self.admins.length==1&&self.users.length>1
        users=self.users-[user]
        self.admins.push users.first
      end
      self.admins.destroy user
    end
  end
end
