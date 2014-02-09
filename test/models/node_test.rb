require 'test_helper'


class NodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @node = node.new
  end

  def is_pmodoro
    assert_instance_of(pomodoro, @node)
  end
end
