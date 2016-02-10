class GroupInvitations < ActiveRecord::Base
  belongs_to :group

  def accept_me(invitee_id)
    @group = self.group
    #check validity of this request
    user = User.find(invitee_id)
    if self.user_id == invitee_id.to_i && self.expired.nil? && self.accept.nil?
      if ! @group.users.include? user
        group.users.push user
      end
      self.accept = true
      self.expired = true
      self.save
      return true
    else
      return false
    end
  end

  #TODO background job to purge this table after 7 days
  def reject(invitee_id)
    @group = self.group
    #check validity of this request
    if self.user_id == invitee_id.to_i && self.expired.nil? && self.accept.nil?
      self.accept = false
      self.expired = true
      self.save
      @group.send_admin_message(@user,"User #{self.user.name} has rejected your invitation to join the group", "Invitation rejected")
      return true
    else
      return false
    end
  end
end
