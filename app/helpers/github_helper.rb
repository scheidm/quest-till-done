module GithubHelper
  #github following

  def authorize
    @github  = Github.new client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
    # TODO we need a working url
    address = @github.authorize_url redirect_uri: 'http://khuang.org/abc', scope: 'repo'
    redirect_to address
  end

  # Get Access Token
  def callback
    authorization_code = params['11e5c37e512925d7de8f']
    access_token = github.get_token authorization_code
    #store this value to user
    access_token.token   # => returns token value
    # ??NO current user anymore
    @user.update_attribute(:github_token, access_token)
  end

  # Login for github information
  # @return [Github] Github Session
  def login
    #@github_ = Github.new(:oauth_token => @user.github_token)

    @github = Github.new login:'x', password:'x#'
    #@github = Github.new oauth_token:'11e5c37e512925d7de8f', client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995', login:'codingsnippets'

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

  # List Projects
  # @return [Hash] The full list of projects
  def list_projects
    @repos =  Hash.new
    JSON.parse(@github.repos.list.to_json).each do |t|
      @repos[(t["name"])] = t["html_url"]
    end
    return @repos
  end


  # List Issues
  # @return [Hash] The full list of issues
  def list_issues(username, projectname)
    @issues = Hash.new
    issueobj =  @github.issues.list :user => username, :repo => projectname
    JSON.parse(issueobj.to_json).each do |t|
      @issues[t["title"]] = t["html_url"]
    end
    return @issues
  end



  #TODO need to take second look at the format
  def save(project)

  end


  # Get commits from a project

  def commits(username, projectname)
    @commits = Hash.new
    JSON.parse((@github.repos.commits.all username,projectname).to_json).each do |t|
      @commits[t["commit"]["message"]] = t["html_url"]
    end
    @commits
  end

  # Import a project to QTD
  # Note: this should be run only when first time import is initiated
  def import(username, projectname)
    project= Quest.new
    project.name = projectname


    # encounter stop
    #currentEnounter = Encounter.last
    #currentEnounter.stop

    #@timer.stop_timer
    #@timer.reset


    # new encounter

    commit_encounter =  Encounter.new
    compaign = Campaign.new


    @commits.each do |description, url|
      new_record = Record.new
      #new_record.record_type = 'Link'
      new_record.description = description
      new_record.url = url
      new_record.save
      create_round( new_record, action_name, commit_encounter)
    end

    @issues.each do |description, url|
      new_record = Record.new
      #new_record.recrod_type = 'Link'
      new_record.description = description
      new_record.url = url
      new_record.save
    end



    # end encounter
    commit_encounter.save


    # create new encounter and add reamaing time
    remaining_encounter = Encounter.new
    # TODO NO resume function in timer???
    #@timer.resume
    #project.save



  end
end