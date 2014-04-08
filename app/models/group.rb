# A user-defined group, whose members all share common projects and activity
# timelines
class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :admins, class_name: "User", join_table: "admins_groups"
  # Leave the group while preventing orphan groups. If the user is the last
  # admin, the function will automatically promote the oldest member to group
  # admin before leaving. If the user is the last member in the group, the
  # function will delete the group and associated campaigns from the database
  def leave
    @users_group = group.users_groups.where(user_id: current_user.id).first

    if group.last_owner?(current_user)
      redirect_to(profile_groups_path, alert: "You can't leave group. You must add at least one more owner to it.")
    else
      @users_group.destroy
      redirect_to(profile_groups_path, info: "You left #{group.name} group.")
    end
  end
end
