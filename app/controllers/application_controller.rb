# Default controller in Rails, from which all other users inherit
class ApplicationController < ActionController::Base
  include Consul::Controller
#  require_power_check
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter  :configure_permitted_parameters, if: :devise_controller?
  before_filter :load_user
  before_filter :authenticate_user!

  protected

  current_power do
    Power.new(@user)
  end

  # Once a user is signed in, the application will use this to ensure that the
  # header displays the correct information for the active task of the current
  # user
  def load_user
    if(user_signed_in?)
      @user = User.find(current_user.id)
      @config = @user.config
      @timer = @user.timer
      active_quest = @user.active_quest
      if(active_quest.nil?)
         @active_quest_model = nil
         @active_quest_name = ''
         @active_quest_url = '#'
         @active_quest_campaign_name = ''
         @active_quest__campaign_url = '#'
      else
        @active_quest_model = active_quest
        @active_quest_name = active_quest.name
        @active_quest_url = quest_path(active_quest)
        @active_quest_campaign_name = active_quest.campaign.name
        @active_quest_campaign_url = campaign_path(active_quest.campaign)
      end
    end
  end

  # Will limit parameters to those valid for devise user control, to prevent
  # parameter injection from influencing the security of the site
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  # Will ensure that password timeouts are followed up with prompts for logging back
  # into the program
  def check_password_expiration
    # check inactive mins
    if @user && @user.password_expires_at && @user.password_expires_at < Time.now
      redirect_to new_profile_password_path and return
    end
  end


  # Will generate JSON results for a record search for use in generating
  # autocomplete forms
  def record_autocomplete
    render json:  Record.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  # Will generate aggregate search results from recor and quest searches
  # against a specified query
  # @param query [String] search string specified in SQL-like format specified
  # by the Searchkick gem
  def full_search query
    recs=Records.search query
    quests=Quest.search query
    @results=recs.results+quests.results
  end
end
