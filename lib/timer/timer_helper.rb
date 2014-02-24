# Helper for handling timer
module TimerHelper

  # start timer and create encounter
  def startTimer
    if(Encounter.last.nil? || !Encounter.last.end_time.nil?)
      Encounter.create
    end
    t = Timer.where(:user_id => current_user.id).first
    t.updated_at = Time.now
    t.save
    session[:state] = true
  end

  # pause timer
  def pauseTimer
    current_time = params[:current_time]
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = current_time
    t.save
    session[:state] = false
  end

  # reset timer
  def resetTimer
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
  end

  # restart timer
  def restartTimer

  end

  # get remaining time
  def getTime
    remain_time = current_user.timer.current_time
    encounter = Encounter.last
    session[:state] ||= false
    state = session[:state]
    if(!encounter.nil? && state)
      diff = (Encounter.last.created_at.utc + remain_time - Time.now.utc).to_i
      remain_time = remain_time - (Time.now.utc - current_user.timer.updated_at.utc).to_i
      if(diff < 0)
        encounter.close
        remain_time = setting_time
        session[:state] = false
      end
    end
    data = {current_time: remain_time, state: state}
    return data
  end

  # get setting default time
  def getSettingTime
    setting_time = current_user.timer.setting_time
    data = {setting_time: setting_time}
    return data
  end


end