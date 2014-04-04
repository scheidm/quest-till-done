require 'test_helper'
Devise::TestHelpers
require 'test/unit'

class EncountersControllerTest < ActionController::TestCase

  def setup
    sign_in User.first
  end

  test 'Encounter Should Get Index' do
    get :index
    assert_response :success

  end


  def teardown
    # Do nothing
  end


end