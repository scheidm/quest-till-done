require "test_helper"

class RoundTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @quest_round = Round.find(1)
    @campaign_round = Round.find(1)
  end

  def teardown
    @new_round = nil
  end



  test "Round must have campaign" do
    @empty_campaign = Campaign.new
    assert !Round.create_event(Record.find(1), "test", @empty_campaign), 'Round without campaign is saved'
  end


  test 'Round must have operation' do
    assert !Round.create_event(Record.find(1), "", @campaign_round), 'Round without operation is saved'
  end






end
