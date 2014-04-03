require "test_helper"

class CampaignTest < ActiveSupport::TestCase
  def setup 
    Rails::logger.info Round.first.inspect
    Campaign.reindex
    Record.reindex
    Quest.reindex
    @one=Campaign.find(1)
  end

  test "Search campaign fields verbatim" do
    x=Campaign.search "Genma"
    assert_equal 1, x.results.length
    x=Campaign.search "old man"
    assert_equal 1, x.results.length
  end

  test "Ensure quests do not get indexed in with quest" do
    x=Campaign.search "panda"
    assert_equal 0, x.results.length
  end

  test "Search for record of dependant quest" do
    x=Campaign.meta_search "Red"
    assert_equal 1, x.length
  end

  test "accurately calculate progress" do
    Rails::logger.info @one.quests.length
    assert_equal 33.33333333333333, @one.progress
  end

  test "grab encounter from appropriate rounds" do
    assert_equal 1, @one.timeline.length
  end
end
