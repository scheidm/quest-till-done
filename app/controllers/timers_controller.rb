class TimersController < ApplicationController

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

  def get_setting_time
    setting_time = current_user.timer.setting_time
    data = {setting_time: setting_time}
    render :text => data.to_json
  end

  def start_timer
    if(Encounter.last.nil? || !Encounter.last.end_time.nil?)
      Encounter.create
    end
    session[:state] = true
    render :nothing => true
  end

  def stop_timer
    current_time = params[:current_time]
    t = Timer.where(:user_id => current_user.id).first
    t.current_time = current_time
    t.save
    session[:state] = false
    render :nothing => true
  end

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
end