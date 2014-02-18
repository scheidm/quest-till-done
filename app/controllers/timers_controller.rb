# Controller for Timer related functions
class TimersController < ApplicationController

  # Get current remaining time on the time counter
  # @return [JSON] the total remaining time or setting time
  def get_current_time
    current_time = current_user.timer.current_time
    encounter = Encounter.last
    session[:state] ||= false
    diff = current_time
    state = session[:state]
    if(!encounter.nil? && state)
      diff = (Encounter.last.created_at.utc + current_time - Time.now.utc).to_i
      if(diff < 0)
        encounter.close
        diff = setting_time
        session[:state] = false
      end
    end
    data = {current_time: diff, state: state}
    render :text => data.to_json
  end

  # Get user's default time length for an encounter
  # @return [JSON] the default time length in seconds
  def get_setting_time
    setting_time = current_user.timer.setting_time
    data = {setting_time: setting_time}
    render :text => data.to_json
  end

  # Start the timer countdown
  # Open an encounter if there is not one currently active
  def start_timer
    if(Encounter.last.nil? || !Encounter.last.end_time.nil?)
      Encounter.create
    end
    session[:state] = true
    render :nothing => true
  end

  # Stop/Pause the timer and record the current remaining time
  # @param current_time [String] current remaining time on the timer in seconds
  def stop_timer
    current_time = params[:current_time]
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = current_time
    t.save
    session[:state] = false
    render :nothing => true
  end

  # Stop and reset the timer to the user's default time length
  # Closes any last opened encounter
  # @return [String] the default time length in seconds
  def reset_timer
    session[:state] = false
    encounter = Encounter.last
    if(encounter.nil?)
      return
    elsif(encounter.end_time.nil?)
      encounter.close
    end
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = t.setting_time
    t.save
    get_setting_time
  end

  # Restart the timer when then timer reaches 0
  # Close any previous encounter, and start the timer again
  def restart_timer

  end

  # Extend the timer duration for manual mode
  def extend_timer

  end
end