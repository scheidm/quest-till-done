require "test_helper"

class QuestTest < ActiveSupport::TestCase
  def setup 
    Quest.reindex
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

  test "Search related record description" do
    Record.reindex
    Rails.logger.info "TESTING"
    Rails.logger.info Record.first.description
    x=Quest.search "Red", facets: [:record_desc]
    assert_equal 1, x.results.length
  end
end
