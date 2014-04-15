module GithubHelper



  # # Get Access Token
  # def callback  
  #   (@github.get_token params['access_token']).token
  #   #store this value to user table
  #   current_user.github_access_token =  access_token.token
  # end

  

  # Login for github information
  # @return [Github] Github Session
  def login
    @github = Github.new oauth_token: @user.github_access_token, client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
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
    @repos = Hash.new
    @github.repos.list.each do |t|
      @repos[(t["name"])] = t["html_url"]
      if !GithubRepo.find_by github_user: t["owner"]["login"], url: t["html_url"]
        GithubRepo.create({user: @user,
                           project_name: t["name"],
                           url: t["html_url"],
                           github_user: t["owner"]["login"],
                           created_at: t['created_at'],
                           updated_at: t['updated_at'],
                           imported: nil
                          })
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
    issueobj = @github.issues.list :user => username, :repo => projectname
    issueobj.each do |t|
      @issues[t['title']] = t['html_url']
      if encounter || campaign
        unless Quest.find_by description: t['html_url']

          new_issue = Quest.create({campaign_id: campaign.id,
                                    name: t['title'],
                                    description: t['html_url'],
                                    user_id: @user.id,
                                    status: 'Open',
                                    parent: campaign,
                                    created_at: t['created_at'],
                                    updated_at: t['updated_at']
                                   })

          create_round(new_issue, action_name, campaign)

        end
      end
    end

    # set for latest issue check
    #GithubRepo.find_by(project_name: projectname, github_user: username).latest_issue =  issueobj.first.created_at

  end

  # Get commits from a project
  def list_commits(username, projectname, encounter, campaign)
    @commits = Hash.new
    list_branches username, projectname
    @branches.each do |branch_name, branch_sha|
      @github.repos.commits.list(username, projectname, :sha => branch_sha).each do |t|

        @commits[t["commit"]["message"]] = t["html_url"]

        # if encounter && campaign
        unless Record.find_by sha: t["sha"]
          new_commit = Commit.create({encounter_id: encounter.id,
                                      quest_id: campaign.id,
                                      description: t["commit"]["message"],
                                      url: t["html_url"],
                                      user_id: @user.id,
                                      sha: t["sha"]
                                     })

          create_round(new_commit, action_name, campaign)
        end
        # end
      end
    end
  end

  # Import a project to QTD
  # Note: this should be run only when first time import is initiated
  def initial_import(username, projectname)
    # set import status
    project = GithubRepo.find_by(github_user: username, project_name: projectname, user_id: @user.id)

    if project.imported.nil? || !project.imported

      project.imported = 1
      project.save


      # encounter stop
      if Encounter.last
        Encounter.last.close
      end

      # new encounter
      import_campaign = Campaign.create({name: projectname,
                                         description: "Imported Project for #{projectname}",
                                         user_id: @user.id
                                        })

      create_round(import_campaign, action_name, import_campaign)

      # import commits & issues
      list_commits username, projectname, Encounter.last, import_campaign
      list_issues username, projectname, Encounter.last, import_campaign


    end


  end

  # Update Issues and Commits
  def update_project(username, projectname)

    #handle commits
    list_commits username, projectname, Encounter.last, Campaign.last
    #handle issues
    list_issues username, projectname, Encounter.last, Campaign.last
  end

  # Delete Project From QTD
  # @param username     Github User Name
  # @param projectname  Github Project Name
  def del_project(username, projectname)
    project = GithubRepo.find_by(github_user: username, project_name: projectname, user_id: @user.id)
    project.imported = false
    project.save


    target_campaign = Quest.find_by(type: 'Campaign', name: projectname, campaign_id: nil)
    #destroy all Rounds
    Round.destroy_all(campaign_id: target_campaign.id)
    #destroy all Quests related to campaign
    Quest.destroy_all(campaign_id: target_campaign.id)
    #destroy the campaign itself
    Quest.destroy(target_campaign.id)

    #destroy all Commits

    Record.destroy_all(type: 'Commit', github_username: username, github_projectname: projectname)

    #make sure there is an encounter there
    create_round(project, action_name, Campaign.last)
  end

end
