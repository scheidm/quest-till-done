require "test_helper"

class ActionsControllerTest < ActionController::TestCase

  before do
    @action = actions(:one)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:actions)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Action.count') do
      post :create, action: {  }
    end

    assert_redirected_to action_path(assigns(:action))
  end

  def test_show
    get :show, id: @action
    assert_response :success
  end

  def test_edit
    get :edit, id: @action
    assert_response :success
  end

  def test_update
    put :update, id: @action, action: {  }
    assert_redirected_to action_path(assigns(:action))
  end

  def test_destroy
    assert_difference('Action.count', -1) do
      delete :destroy, id: @action
    end

    assert_redirected_to actions_path
  end
end
