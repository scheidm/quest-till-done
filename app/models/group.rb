# A user-defined group, whose members all share common projects and activity
# timelines
class Group < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns
  has_and_belongs_to_many :users
  has_and_belongs_to_many :admins, class_name: "User", join_table: "admins_groups"
  # Leave the group while preventing orphan groups. If the user is the last
  # admin, the function will automatically promote the oldest member to group
  # admin before leaving. If the user is the last member in the group, the
  # function will delete the group and associated campaigns from the database
  def leave
    if self.admins.includes? @user
      if self.admins.length==1
        users=self.users-[@user]
        self.admins.push users.first
      end
      self.admins.destroy @user
    end
    self.users.destroy @user
  end
end
