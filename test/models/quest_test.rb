require "test_helper"

class QuestTest < ActiveSupport::TestCase
  def setup 
    Quest.reindex
    Campaign.reindex
    Record.reindex
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
end
