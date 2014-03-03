require "test_helper"

class QuestTest < ActiveSupport::TestCase
  test "Search quest name" do
    Quest.reindex
    x=Quest.search "panda"
    assert_equal 1, x.results.length
  end
end
