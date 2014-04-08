require "test_helper"

class TimerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @timer =  Timer.find(1)
    @timer.init
  end

  test 'Timer is on' do
    assert @timer.enabled
  end

  test 'Timer mode is auto' do
    assert @timer.mode == 'auto'
  end

  test 'Timer state is not empty' do
    assert !@timer.state
  end


end
