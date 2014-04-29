# Helper for handling timer
module TimerHelper

  # Will start timer and create an encounter if neccessary
  def start_timer
    if(current_user.last_encounter.nil? || !current_user.last_encounter.end_time.nil?)
      encounter = Encounter.new
      encounter.user_id = current_user.id
      encounter.save
    end
    @timer.updated_at = Time.now
    @timer.save
    current_user.timer.set_state(true)
  end

  # Will pause the timer
  def stop_timer
    current_time = params[:current_time]
    @timer.current_time = current_time
    @timer.save
    current_user.timer.set_state(false)
  end

  # Will reset the timer
  def reset_timer
    current_user.timer.set_state(false)
    encounter = current_user.last_encounter
    if(encounter.nil?)
      return
    elsif(encounter.end_time.nil?)
      encounter.close
    end
    @timer.current_time = @config.encounter_duration
    @timer.save
  end

  # Will get remaining time on the timer
  def get_current_time
    remain_time = @timer.current_time
    setting_time = @config.encounter_duration
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

  # Will try to reset time if in auto mode
  def restart_timer
    if(current_user.timer.mode == 'auto')
      reset_timer
      start_timer
      return get_current_time.merge get_setting_time
    else
      return {state: get_timer_state}
    end
  end

  # Will get default time from user configuration settings
  def get_setting_time
    return {setting_time: @config.encounter_duration}
  end

  # Will get current state of the timer
  def get_timer_state
    return current_user.timer.get_state
  end

  # Will get the default time for a short break from user configuration
  def get_break_time
    return {break_time: @config.short_break_duration}
  end

  # Will extend the current time on the timer
  def extend_timer
    if(@user.timer.mode == 'manual')
      current_time = params[:current_time]
      new_time = current_time.to_i + @user.config.encounter_extend_duration.to_i
      @timer.current_time = new_time
      @timer.save
      return {new_time: new_time}
    end
  end

  # Will start a short break
  def start_break
    if(@user.timer.mode == 'manual')
      encounter = current_user.last_encounter
      if(encounter.nil?)
        return
      elsif(encounter.end_time.nil?)
        encounter.close
      end
      encounter = Encounter.new
      encounter.user_id = current_user.id
      encounter.break_flag = true
      encounter.save
      @timer.current_time = @config.short_break_duration
      @timer.updated_at = Time.now
      @timer.save
      current_user.timer.set_state(true)
    end
  end
end
