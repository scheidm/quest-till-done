require "test_helper"

class ActionsControllerTest < ActionController::TestCase

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
      post :create, task: { :name => 'test' }
    end
    assert_equal 'test', assigns(:action).name
    assert_redirected_to action_path(assigns(:action))
  end

  def test_show
    action = actions(:one)
    get :show, id: action
    assert_response :success
  end

  def test_edit
    action = actions(:one)
    get :edit, id: action
    assert_response :success
  end

  def test_update
    action = actions(:one)
    put :update, id: action, task: { :name => 'test'  }
    assert_equal 'test', assigns(:action).name
    assert_redirected_to action_path(assigns(:action))
  end

  def test_destroy
    action = actions(:one)
    assert_difference('Action.count', -1) do
      delete :destroy, id: action
    end

    assert_redirected_to actions_path
  end
end
