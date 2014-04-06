require "test_helper"

class RoundTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @campaign_round = Campaign.find(1)
    @round = Round.find(1)
  end

  def teardown
    @new_round = nil
  end



  test 'Round must have campaign' do
    @empty_campaign = Campaign.new
    assert !Round.create_event(Record.find(1), 'test', @empty_campaign), 'Round without campaign is saved'
  end


  test 'Round must have operation' do
    assert !Round.create_event(Record.find(1), "", @campaign_round), 'Round without operation is saved'
  end

  test 'Round can find model' do
    assert !!@round.related_obj
  end

  test 'Round can find link' do
    assert !!@round.related_link
  end






end
