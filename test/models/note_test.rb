require "test_helper"

class NoteTest < ActiveSupport::TestCase
  def setup
    Record.reindex
  end

  test "Search note" do
    x = Record.search "*", type: [Note]
    assert_equal 1, x.results.length
    x.results.each do |data|
      assert_equal Note, data.class
    end
  end
end
