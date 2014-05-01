# timelines
class Group < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns
  has_many :rounds
  has_many :github_repos
  has_and_belongs_to_many :users
  has_and_belongs_to_many :admins, class_name: "User", join_table: "admins_groups"
  # Leave the group while preventing orphan groups. If the user is the last
  # admin, the function will automatically promote the oldest member to group
  # admin before leaving. If the user is the last member in the group, the
  # function will delete the group and associated campaigns from the database
  def leave user
    demote user
    self.users.destroy user
  end

  def demote user
    if self.admins.include? user
      if self.admins.length==1
        users=self.users-[user]
        self.admins.push users.first
      end
      self.admins.destroy user
    end
  end
end
