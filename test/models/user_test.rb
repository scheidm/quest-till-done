
class UserTest < ActiveSupport::TestCase
   def setup
     @user= User.find(2)
   end

   test "models created successfully for new user" do
     @user.new_user_setup
     assert_not_nil @user.config
     assert_not_nil @user.timer
     assert_equal 1, @user.encounters.length
     assert_equal 1, @user.campaigns.length
     assert_equal 3, @user.quests.length
   end
     
end
