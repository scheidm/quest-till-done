require "test_helper"

class CommitTest < ActiveSupport::TestCase
  def setup
    Record.reindex
  end

  test "Search commit" do
    x = Record.search "*", type: [Commit]
    assert_equal 1, x.results.length
    x.results.each do |data|
      assert_equal Commit, data.class
    end
  end
end
