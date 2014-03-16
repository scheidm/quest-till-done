
class UserController < ApplicationController

  include RoundHelper
  include GithubHelper


  def authorize
    @github = current_user.github
    redirect_to @github.authorize_url redirect_uri: "http://art.cs.drexel.edu:8080/users/github_callback", scope: 'repo'
  end

  # Get Github Access Token
  def callback         
    @github = current_user.github
    token = (@github.get_token params['code']).token
    #store this value to user table
    current_user.github_access_token = token
    current_user.save
  end


  def index
    @user = current_user
    @recent_activities = Round.all.order(id: :desc).limit(10)
  end
  def getFriends
    @friends = current_user.getFriends
  end
  def getGroups
    @groups = current_user.getGroups
  end
  # define avatar by default value
  # @return [Binary] image file
  def show_avatar

  end

  def settings
   @config=UserConfig.where('user_id = (?)',@user.id).first
  end

  # destroy avatar
  def destroy_avatar

  end

  def show
    if current_user.github_access_token.nil?
      github_authorize
    else
      github_list
    end


  end

  def github_authorize
      authorize
  end

  def github_callback
    callback
  end

  def github_list
    login
    list_projects
    @projects = GithubRepo.where(user_id: current_user)
  end

  def github_project_import
    login
    initial_import params[:github_user], params[:repo_name]
  end

  def github_project_del
    login
    del_project params[:github_user], params[:repo_name]
  end

  def github_update
    login
    update_project params[:github_user], params[:repo_name]
  end

  def update
    @user_config = UserConfig.find(params[:id])
    respond_to do |format|
      if @user_config.update(user_config_params)
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render user: 'setting' }
        format.json { render json: @user_config.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_config_path
    return 'update'
  end

  def user_config_params
    params.require(:user_config).permit(:id, :encounter_duration, :short_break_duration, :extended_break_duration, :encounter_extend_duration, :user_id, :status, :importance, :deadline)
  end

  def github_background_jobs
    login? || login
    github_update_all_projects
  end

  handle_asynchronously :github_background_jobs



end
