# GitHub controller to authenticate with Github
class GitHubController  < ApplicationController
  attr_accessor :@github, @issues, @repos
  private :@github, @issues, @repos

  # Authorize for user to authenticate
  def authorize
    @github  = Github.new client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
    # we need a working url
    address = github.authorize_url redirect_uri: 'http://khuang.org', scope: 'repo'
    redirect_to address
  end

  # Return back to user's previous location
  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    #store this value to user
    access_token.token   # => returns token value

    # ??NO current user anymore
    @user.update_attribute(:github_token, access_token)
  end

  # Login for github information
  # @return [Github] Github Session
  def login
    @github_ = Github.new(:oauth_token => @user.github_token)
  end

  # Check if login is sucessful
  # @return [bool] Logged in or not
  def login?
    if login
      return true
    else
      return nil
    end
  end

  # List project lists
  # @return [Array] The full list of projects
  def projectList
      @repos = Github::Repos.new
      @repos.list
  end

  # List Issues
  # @return [Array] The full list of issues
  def issues(projectname)
    # TODO determine project wise or all issues.
    @issues = Github::Issues.new
    @issues.list(username, projectname)
  end



  #TODO need to take second look at the format
  def save(project)

  end


  # Get commits from a project
  def pullCommits
    @commits = @github.repos.commits.all
    #TODO choose save format
  end


end