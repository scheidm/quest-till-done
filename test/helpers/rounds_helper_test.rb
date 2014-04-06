require 'test/unit'

class RoundHelperTest < ActionView::TestCase
  include Devise::TestHelpers
  include RoundHelper
  include TimerHelper

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @campaign = Quest.find(1)
    @timer = current_user.timer
  end

  test 'Can create a new Round' do
    assert !!create_round(Record.find(1), 'create', @campaign), 'Cannot create round properly'
  end


  def current_user
    User.first
  end
end