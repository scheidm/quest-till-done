require 'test_helper'
include Devise::TestHelpers

class RecordsControllerTest < ActionController::TestCase

  def setup
    initialize_record
    sign_in User.first
    request.env["HTTP_REFERER"] = "/records/testing"
  end

  def teardown
    @record = nil
  end

  test "Get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:records)
  end

  test "Get show" do
    get :show, id: @record.id
    assert_response :success
    assert_not_nil assigns(:record)
  end

  test "Test create record" do
    assert_difference('Record.count') do
      post :create, record: {description: 'Testing', quest_id: Quest.first.id}
    end

    assert_redirected_to record_path(assigns(:record))
    assert_not_nil(Record.find_by(description: 'Testing'))
  end

  test "Test delete record" do
    assert_difference('Record.count', -1) do
      delete :destroy, id: @record.id
    end

    assert_response :found  end

  def initialize_record
    @record = Record.find(1)
    y = @record
  end
end