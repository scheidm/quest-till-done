require "test_helper"

class RecordTest < ActiveSupport::TestCase
  def setup 
    Record.reindex
  end

  test "Search record fields verbatim" do
    x=Record.search "Red"
    assert_equal 1, x.results.length
    x=Record.search "thorns"
    assert_equal 1, x.results.length
  end
end
