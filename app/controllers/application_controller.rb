class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter  :configure_permitted_parameters, if: :devise_controller?
  before_filter :load_user
  before_filter :authenticate_user!

  protected

  def load_user
    @user = current_user
    @active_quest = Object.new
    active_quest = current_user.active_quest
    if(active_quest.nil?)
       @active_quest_name = ''
       @active_quest_url = '#'
       @active_quest_campaign_name = ''
       @active_quest__campaign_url = '#'
    else
      @active_quest_name = active_quest.name
      @active_quest_url = quest_path(active_quest)
      @active_quest_campaign_name = active_quest.campaign.name
      @active_quest__campaign_url = campaigns_path(active_quest.campaign)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
