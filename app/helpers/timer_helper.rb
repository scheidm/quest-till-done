# Helper for handling timer
module TimerHelper

  # start timer and create encounter
  def start_timer
    if(current_user.last_encounter.nil? || !current_user.last_encounter.end_time.nil?)
      encounter = Encounter.new
      encounter.user_id = current_user.id
      encounter.save
    end
    t = Timer.where(:user_id => current_user.id).first
    t.updated_at = Time.now
    t.save
    current_user.timer.set_state(true)
  end

  # pause timer
  def stop_timer
    current_time = params[:current_time]
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = current_time
    t.save
    current_user.timer.set_state(false)
  end

  # reset timer
  def reset_timer
    current_user.timer.set_state(false)
    encounter = current_user.last_encounter
    if(encounter.nil?)
      return
    elsif(encounter.end_time.nil?)
      encounter.close
    end
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = @config.encounter_duration
    t.save
  end

  # get remaining time
  def get_current_time
    remain_time = current_user.timer.current_time
    setting_time = current_user.timer.setting_time
    encounter = current_user.last_encounter
    state = get_timer_state
    if(!encounter.nil? && state)
      diff = (current_user.timer.updated_at + remain_time - Time.now.utc).to_i
      remain_time = remain_time - (Time.now.utc - current_user.timer.updated_at.utc).to_i
      if(diff < 0)
        encounter.close
        remain_time = setting_time
        current_user.timer.set_state(false)
        state = get_timer_state
      end
    end
    data = {current_time: remain_time, state: state}
    return data
  end

  # try to reset time if auto mode
  def restart_timer
    if(current_user.timer.mode == 'auto')
      reset_timer
      start_timer
      return get_current_time.merge get_setting_time
    else
      return {state: get_timer_state}
    end
  end

  # get setting default time
  def get_setting_time
    setting_time = current_user.timer.setting_time
    data = {setting_time: setting_time}
    return data
  end



  # get current state of the timer
  def get_timer_state
    return current_user.timer.get_state
  end
end
