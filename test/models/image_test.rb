require "test_helper"

class ImageTest < ActiveSupport::TestCase
  def setup
    Record.reindex
  end

  test "Search image" do
    x = Record.search "*", type: [Image]
    assert_equal 1, x.results.length
    x.results.each do |data|
      assert_equal Image, data.class
    end
  end
end
