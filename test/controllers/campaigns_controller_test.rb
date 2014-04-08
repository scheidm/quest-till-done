require 'test_helper'
include Devise::TestHelpers

class CampaignsControllerTest < ActionController::TestCase
  def setup
    @campaign = Campaign.find(1)
    @user=User.first
    Rails::logger.info "\n\n\n"
    Rails::logger.info @campaign.inspect
    sign_in @user
    request.env["HTTP_REFERER"] = "/campaigns/testing"
  end

  def teardown
    @campaign = nil
  end

  test "Get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaigns)
  end

  test "Get show" do
    get :show, id: @campaign.id
    assert_response :redirect
    assert_not_nil assigns(:campaign)
  end

  test "Test create campaign" do
    assert_difference('Campaign.count') do
      post :create, campaign: {name: 'Test', description: 'Testing',user_id: @user.id, status: 'Open'}
    end

    assert_redirected_to campaign_path(assigns(:campaign))
    assert_not_nil(Campaign.find_by(description: 'Testing'))
  end

  test "Test delete campaign" do
    assert_difference('Campaign.count', -1) do
      delete :destroy, id: @campaign.id
    end

    assert_response :found
  end

end
