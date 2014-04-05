require 'test_helper'
require 'test/unit'

class TimersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  def setup
    sign_in User.first
  end

  test 'Get remaining time'  do

  end
end