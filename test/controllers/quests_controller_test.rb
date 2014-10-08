require 'test_helper'
include Devise::TestHelpers

class QuestsControllerTest < ActionController::TestCase
  def setup
    @quest = Quest.find(2)
    @campaign = @quest.campaign
    @user=User.first
    Rails::logger.info @quest.inspect
    Rails::logger.info @campaign.inspect
    Rails::logger.info @quest.inspect
    sign_in @user
    request.env["HTTP_REFERER"] = "/quests/testing"
  end

  def teardown
    @quest = nil
  end

  test "Get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quests)
  end

  test "Get show" do
    get :show, id: @quest.id
    assert_response :redirect
    assert_not_nil assigns(:quest)
  end

  test "Test create quest" do
    assert_difference('Quest.count') do
      post :create, quest: {name: 'Test', description: 'Testing',group_id: @user.wrapper_group.id, status: 'Open', campaign_id: 1, parent_id: 1}
    end

    assert_redirected_to campaign_path(Campaign.find(1).slug)
    assert_not_nil(Quest.find_by(description: 'Testing'))
  end

  test "Test delete quest" do
    assert_difference('Quest.count', -1) do
      delete :destroy, id: @quest.id
    end

    assert_response :found
  end

  test "can successfully set active quest" do
    @active=@user.active_quest
    post( :set_active, {id: @quest.id})
    @user.reload
    assert_not_same(@active, @user.active_quest)
 end

  test "update quest" do
    put :update, id: @quest.id, quest: {status: 'Closed'}
    assert_redirected_to quest_path(assigns(:quest))
  end

  test "close active quest" do
    @user.active_quest=@quest
    @user.save
    put :update, id: @quest.id, quest: {status: 'Closed'}
    assert_redirected_to quest_path(assigns(:quest))
    @user.reload
    assert_same(@user.active_quest.id, 5)
  end
end
