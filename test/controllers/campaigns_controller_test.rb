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
    assert_response :success
    assert_not_nil assigns(:campaign)
  end

  test "Test create campaign" do
    post :create, campaign: {name: 'Test', description: 'Testing',group_id: @user.wrapper_group.id, status: 'Open'}
    assert_not_nil( Campaign.where(description: "Testing") )
    assert_redirected_to campaign_path(assigns(:campaign))
  end

  test "Test delete campaign" do
    dId = @campaign.id
    delete :destroy, id: dId
    assert_response :found
    assert_nil Campaign.find_by( name: "genma")
  end

end
