require "test_helper"

class QuestTest < ActiveSupport::TestCase
  def setup 
    Quest.reindex
    Campaign.reindex
    Record.reindex
    @one=Quest.find(1)
    @two=Quest.find(2)
  end

  test "Search quest fields verbatim" do
    x=Quest.search "panda"
    assert_equal 1, x.results.length
    x=Quest.search "don't touch!"
    assert_equal 1, x.results.length
  end

  test "Search quest name case sensitivity" do
    x=Quest.search "Panda"
    assert_equal 1, x.results.length
  end

  test "Search quest name pluralized" do
    x=Quest.search "Pandas"
    assert_equal 1, x.results.length
  end

  test "Search related link description" do
    x=Quest.search "Red"
    assert_equal 1, x.results.length
  end

  test "Search related link quote" do
    x=Quest.search "thorn"
    assert_equal 1, x.results.length
  end

  test "Search related note description" do
    x=Quest.search "squirrel"
    assert_equal 1, x.results.length
  end

  test "distinguish quest from campaign" do
    assert_equal true, @one.campaign?
    assert_equal false, @two.campaign?
  end

  test "accurately return campaign" do
    assert_equal @one, @two.get_campaign
    assert_equal @one, @one.get_campaign
  end

  test "accurately determine ancestors" do
    assert_equal false, @two.is_ancestor(@one)
    assert_equal  true, @one.is_ancestor(@two)
  end
end
