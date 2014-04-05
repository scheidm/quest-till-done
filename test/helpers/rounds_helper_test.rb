require 'test/unit'

class RoundHelperTest < ActionView::TestCase
  include Devise::TestHelpers

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @campaign = Quest.find(1)
    @current_user = sign_in(User.first)

  end

  test 'Can create a new Round' do
    assert !create_round(Record, "create", @campaign)
  end
end