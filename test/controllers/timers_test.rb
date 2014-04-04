require 'test_helper'
include Devise::TestHelpers
require 'test/unit'

class TimersControllerTest < ActionController::TestCase
  def setup
    initialize_timer
    sign_in User.first

  end

  test 'Get remaining time'  do

  end
end