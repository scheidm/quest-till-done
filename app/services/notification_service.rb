# NotificationService class
#
# Used for notifying users with emails about different events
#
# Ex.
#   NotificationService.new.new_issue(issue, current_user)
#
class NotificationService

  # Notify new user with email after creation
  def new_user(user)
    # Don't email omniauth created users
    mailer.new_user_email(user.id, user.password) unless user.extern_uid?
  end

  def new_group_member(users_group)
    mailer.group_access_granted_email(users_group.id)
  end

  def update_group_member(users_group)
    mailer.group_access_granted_email(users_group.id)
  end

  def project_was_moved(project)
    recipients = project.team.members
    recipients = reject_muted_users(recipients, project)

    recipients.each do |recipient|
      mailer.project_was_moved_email(project.id, recipient.id)
    end
  end

protected

  def mailer
    Notify.delay
  end
end
