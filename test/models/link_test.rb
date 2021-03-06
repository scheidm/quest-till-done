require "test_helper"

class LinkTest < ActiveSupport::TestCase
  def setup
    Record.reindex
  end

  test "Search link" do
    x = Record.search "*", type: [Link]
    assert_equal 1, x.results.length
    x.results.each do |data|
      assert_equal Link, data.class
    end
  end
end
