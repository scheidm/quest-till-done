require "test_helper"

class CampaignTest < ActiveSupport::TestCase
  def setup 
    Campaign.reindex
    Record.reindex
    Quest.reindex
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
end
