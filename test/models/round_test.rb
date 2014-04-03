require "test_helper"

class RoundTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @quest_round = Round.find(1)
    @campaign_round = Round.find(1)
  end

  test "Round must have encounter" do
    quest_me = Round.new
    quest_me.campaign_id = 1
    quest_me.created_at= Time.now
    quest_me.event_description = "create"
    quest_me.type = "Quest"
    assert !quest_me.save
  end

  test "Round must have campaign" do
    quest_me = Round.new
    quest_me.quest_id = 1
    quest_me.created_at= Time.now
    quest_me.event_description = "create"
    quest_me.type = "Quest"
    assert !quest_me.save  end

  test "Round must have type" do
    quest_me = Round.new
    quest_me.quest_id = 1
    quest_me.campaign_id = 1
    quest_me.created_at= Time.now
    quest_me.event_description = "create"
    assert !quest_me.save
  end

  test "Round must have event description" do
    quest_me = Round.new
    quest_me.quest_id = 1
    quest_me.campaign_id = 1
    quest_me.created_at= Time.now
    quest_me.type = "Quest"
    assert !quest_me.save
  end


  # TODO test for generateTree of related_object and related_link




end
