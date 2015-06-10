class UsersController < ApplicationController

  include RoundHelper
  include GithubHelper


  def authorize
    @github = @user.github
    redirect_to @github.authorize_url redirect_uri: CONFIG[:GITHUB_CALL_BACK_URL], scope: 'repo'
  end

  # Get Github Access Token
  def callback         
    @github = @user.github
    token = (@github.get_token params['code']).token
    #store this value to user table
    @user.github_access_token = token
    @user.save
  end


  def index
    @recent_activities = Round.where(group_id: @user.wrapper_group).order(id: :desc).limit(10)
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
    if @user.github_access_token.nil?
      github_authorize
    else
      github_list
    end
  end

  def github_authorize
      authorize
  end

  def github_revoke
    @user.github_access_token = nil
    GithubRepo.destroy_all(group_id: @user.wrapper_group)
    @user.save
    gflash :success => 'Your Github authentication have been stopped. You need manually revoke from Github website'
    redirect_to welcome_index_path
  end

  def github_callback
    callback
  end

  def github_list
    login(@user)
    list_projects
    @projects = GithubRepo.where("group_id=?", @user.wrapper_group)
  end

  def github_project_import
    # GithubInit.perform_async(@user.id, params[:github_user], params[:repo_name])
    login(@user)
    initial_import @user, params[:github_user], params[:repo_name] , nil
  end

  def github_project_del
    login(@user)
    del_project params[:github_user], params[:repo_name]
  end

  def github_update
    login(@user)
    update_project @user, params[:github_user], params[:repo_name]
  end

  def dismiss
    @user.mailbox.inbox.load.sort.each do |conversation|
      conversation.mark_as_read(@user)
    end
    redirect_to :back
  end
  
  # Update timer config for the user
  # @param id [Integer] User config id
  # @return [Html] User index page
  def update_config
    @user_config = UserConfig.find(params[:id])
    respond_to do |format|
      if @user_config.update(user_config_params)
        format.html { redirect_to users_path, :flash => {:success => 'Timer setting was successfully updated.' }}
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


  def get_td_json
    data = {:id => 0, :attr => { :name => "World View", :description => "World View", :url => '#'}}
    data[:children] = children = []
    @user.groups.each {|group|
      children << group.to_td_json
    }
    render :text => data.to_json
  end



end
