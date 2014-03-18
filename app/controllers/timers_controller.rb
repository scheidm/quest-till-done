# Controller for Timer related functions
class TimersController < ApplicationController
  #require 'timer/timer_helper'
  include TimerHelper

  # Get current remaining time on the time counter
  # @return [JSON] the total remaining time or setting time
  def get_time_current
    render :text => get_current_time.to_json
  end

  # Get user's default time length for an encounter
  # @return [JSON] the default time length in seconds
  def get_time_setting
    render :text => get_setting_time.to_json
  end

  # Start the timer countdown
  # Open an encounter if there is not one currently active
  def start_countdown
    start_timer
    render :nothing => true
  end

  # Stop/Pause the timer and record the current remaining time
  # @param current_time [String] current remaining time on the timer in seconds
  def pause_countdown
    stop_timer
    render :nothing => true
  end

  # Stop and reset the timer to the user's default time length
  # Closes any last opened encounter
  # @return [String] the default time length in seconds
  def reset_countdown
    reset_timer
    render :text => get_setting_time.to_json
  end

  # Restart the timer when then timer reaches 0
  # Close any previous encounter, and start the timer again
  def restart_countdown
    render :text => restart_timer.to_json
  end

  # Extend the timer duration for manual mode
  # @param current_time [Integer] current time in seconds
  def extend_timer

  end

  # Pause the timer and create a new timer for break
  # @return [JSON] break_timer
  def break

  end

  # Extend the current break
  # @return [JSON] Updated break_timer
  def extend_break

  end
end