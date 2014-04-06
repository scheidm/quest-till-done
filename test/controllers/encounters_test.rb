require 'test_helper'
require 'test/unit'

class EncountersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

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