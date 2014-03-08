module GithubHelper

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

    #@github = Github.new login:'x', password:'x'
    @github = Github.new oauth_token:'6f4956e20567870877bf184f03386d5e05a66eb6', client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995', login:'codingsnippets'

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
      if !Githubaccounts.find_by github_user: t["owner"]["login"], url: t["html_url"]
        new_github = Githubaccounts.new
        new_github.user = current_user
        new_github.project_name = t["name"]
        new_github.url = t["html_url"]
        new_github.github_user = t["owner"]["login"]
        new_github.imported = nil
        new_github.save
      end
    end
  end

  #List Branches
  def list_branches(username, projectname)
    @github.repos.user = username
    @github.repos.repo = projectname
    @branches = Hash.new()
    @github.repos.branches.each do |t|
      @branches[t["name"]] = t["commit"]["sha"]
    end
  end

  # List Issues
  # @return [Hash] The full list of issues
  def list_issues(username, projectname, encounter, campaign)
    @issues = Hash.new
    issueobj =  @github.issues.list :user => username, :repo => projectname
    JSON.parse(issueobj.to_json).each do |t|
      @issues[t["title"]] = t["html_url"]
      if encounter || campaign
        if !Record.find_by description: t["title"], url: t["html_url"]
          new_issue = Quest.new
          new_issue.campaign_id = campaign.id
          new_issue.name = t["title"]
          new_issue.description = t["html_url"]
          new_issue.user_id = current_user.id
          new_issue.save
          create_round( new_issue, action_name, campaign)

        end
      end
    end

  end

  # Get commits from a project
  def list_commits(username, projectname, encounter, campaign)
    @commits = Hash.new
    list_branches username, projectname
    @branches.each do |branch_name, branch_sha|
      JSON.parse((@github.repos.commits.list( username,projectname, :sha => branch_sha)).to_json).each do |t|
        @commits[t["commit"]["message"]] = t["html_url"]
        if encounter && campaign
          if !Record.find_by sha: t["sha"]
            new_commit = Commit.new
            new_commit.encounter_id = encounter.id
            new_commit.quest_id = campaign.id
            new_commit.description = t["commit"]["message"]
            new_commit.url = t["html_url"]
            new_commit.github_projectname = projectname
            new_commit.github_username= username
            new_commit.sha = t["sha"]
            new_commit.save
            create_round(new_commit, action_name, campaign)
          end
        end
      end

    end

  end

  # Import a project to QTD
  # Note: this should be run only when first time import is initiated
  def initial_import(username, projectname)
    # set import status
    project = Githubaccounts.find_by(github_user: username, project_name: projectname, user_id: current_user)

    if project.imported.nil?

      project.imported = 1
      project.save


      # encounter stop
      if Encounter.last
        Encounter.last.close
      end

      # new encounter
      import_campaign = Campaign.new
      import_campaign.name = projectname
      import_campaign.description = "Imported Project for #{projectname}"
      import_campaign.user_id = current_user.id
      import_campaign.save

      create_round(import_campaign, action_name, import_campaign)


      # import commits & issues
      list_commits username, projectname, Encounter.last, import_campaign
      list_issues username, projectname, Encounter.last, import_campaign


      #Close Encounter
      Encounter.last.close
    end


  end


  # Delete Project From QTD
  # @param username     Github User Name
  # @param projectname  Github Project Name
  def del_project(username, projectname)

    project = Githubaccounts.find_by(github_user: username, project_name: projectname, user_id: current_user)
    project.imported = nil


    target_campaign = Quest.find_by(type: 'Campaign',  name: projectname, campaign_id:nil)
    Quest.destroy(target_campaign.id)
    Quest.destroy_all(campaign_id: target_campaign.id)


    create_round(Encounter.last, action_name, Campaign.last)


    Record.where(type: Commit).to_a.each do |t|
      t.destroy
      create_round(Encounter.last, action_name, Campaign.last)
    end


  end

end