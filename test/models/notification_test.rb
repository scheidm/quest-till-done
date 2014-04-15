require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "can create a notification from 2 objects" do
    n=Notification.new
    n.dismissed = false
    n.message_type = "JustATest"
    n.link_models( Group.first, User.first )
    n.body = "test notification"
    n.authorization_id = User.find(2)
    n.action_type = "confirm"
    n.save
    assert_equal "Group", n.source_type
    assert_equal "User", n.target_type
  end
end
