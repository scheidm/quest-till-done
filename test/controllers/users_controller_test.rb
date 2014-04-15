require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = User.find(1)
    Rails::logger.info "\n\n\n"
    Rails::logger.info @user.inspect
    sign_in @user
    request.env["HTTP_REFERER"] = "/users/testing"
  end

  def teardown
    @user = nil
  end

  test "Get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:recent_activities)
  end

  test "Get show" do
    get :show, id: @user.id
    assert_response :redirect
    assert_not_nil assigns(:user)
  end

end
