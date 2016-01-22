# Default controller in Rails, from which all other users inherit
class ApplicationController < ActionController::Base
  include ActionView::Helpers::DateHelper, ActionView::Helpers::TagHelper
  include LocalTimeHelper
  include Consul::Controller
#  require_power_check
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :instantiate_variables
  before_filter :authenticate_user!

  protected

  current_power do
    Power.new(@user)
  end

  # Once a user is signed in, the application uses this to ensure that the
  # header displays the correct information for the active task of the current
  # user
  def instantiate_variables
    if(user_signed_in?)
      @model=nil
      @user = User.find(current_user.id)
      @config = @user.config
      @timer = @user.timer
      @active_quest = @user.active_quest
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, no_intra_emphasis: true)
      if(@active_quest.nil?)
         aq = { name: '',
                to_link: nil, 
                campaign: { name: '', to_link: nil}
              }
                                                          
         @active_quest = to_ostruct(aq)
      end
      @journey = @user.campaigns.first
      @muse = @journey.quests.first
      @notification_count = @user.mailbox.inbox(:unread => true).distinct.count
    end
  end

  # Limits parameters to those valid for devise user control, to prevent
  # parameter injection from influencing the security of the site
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  # Ensures that password timeouts are followed up with prompts for logging back
  # into the program
  def check_password_expiration
    # check inactive mins
    if @user && @user.password_expires_at && @user.password_expires_at < Time.now
      redirect_to new_profile_password_path and return
    end
  end

  def record_autocomplete
    render json:  Record.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def full_search query
    recs=Records.search query
    quests=Quest.search query
    @results=recs.results+quests.results
  end

  private
  
  def to_ostruct(object)
    case object
    when Hash
      OpenStruct.new(Hash[object.map {|k, v| [k, to_ostruct(v)] }])
    when Array
      object.map {|x| to_ostruct(x) }
    else
      object
    end
  end
end
