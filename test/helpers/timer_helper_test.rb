require 'test/unit'
require 'timer_helper'

class TimerHelperTest< ActionView::TestCase
  include Devise::TestHelpers
  include TimerHelper

  def setup
    @timer = Timer.find(1)
    @config = UserConfig.find(1)
  end

  test 'Timer can start a timer' do
    start_timer
    assert current_user.timer.state, 'Timer cannot start'
  end

  test 'Timer an stop timer' do
    stop_timer
    assert !current_user.timer.state, 'Timer cannot stop'
  end

  test 'Timer can be reset' do
    reset_timer
    assert !current_user.timer.state, 'Timer state is not close after reset'
    assert_equal(current_user.timer.current_time, @config.encounter_duration, 'Timer remaining time is not reset')
  end

  test 'Timer restart ' do
    restart_timer
    assert current_user.timer.state
    assert_equal(current_user.timer.current_time, @config.encounter_duration, 'Timer remaining time did not restart')
  end

  test 'Timer get setting time' do
    assert !!get_setting_time, 'Cannot get setting time from current user'
  end

  test 'Timer get timer status' do
    assert !!get_timer_state, 'Cannot get timer status from current user'
  end


  def current_user
    User.first

  end
end