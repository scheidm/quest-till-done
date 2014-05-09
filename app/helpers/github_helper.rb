module GithubHelper

  # Login for github information
  # @return [Github] Github Session
  def login
    @github = Github.new oauth_token: current_user.github_access_token, client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
  end

  #initialize github session
  def github_init(username, projectname)
   login unless login?
    # @github:user => username, :repo => projectname
    @github.user = username
    @github.repo = projectname
    return @github
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
    # This function will pull all users' github repositories and check against known repos and update the list
    @repos = Hash.new
    @github.repos.list.each do |t|
      @repos[(t["name"])] = t["html_url"]
      if !GithubRepo.find_by github_user: t["owner"]["login"], url: t["html_url"], group_id: @user.wrapper_group.id
        GithubRepo.create({
                           group_id: @user.wrapper_group.id,
                           project_name: t["name"],
                           url: t["html_url"],
                           github_user: t["owner"]["login"],
                           created_at: t['created_at'],
                           updated_at: t['updated_at'],
                           imported: false
                          })
      end
    end
    return @repos
  end

  #List Branches
  def list_branches(username, projectname)
    @github = github_init(username, projectname)
    @branches = Hash.new()
    @github.repos.branches.each do |t|
      @branches[t["name"]] = t["commit"]["sha"]
    end
    return @branches
  end

  # List Issues
  # @return [Hash] The full list of issues
  def list_issues(username, projectname, encounter, campaign)
    # @issues = Hash.new
    issueobj = @github.issues.list :user => username, :repo => projectname
    issueobj.each do |t|
      # @issues[t['title']] = t['html_url']
      if !Quest.find_by description: t['html_url'], name: t['title'], group_id:@user.id
        new_issue = Quest.create({
                                  campaign_id: campaign.id,
                                  name: t['title'],
                                  description: t['html_url'],
                                  status: 'Open',
                                  parent: campaign,
                                  created_at: t['created_at'],
                                  updated_at: t['updated_at'],
                                  issue_no: t.number.to_i,
                                  group_id: campaign.group_id

                                 })


        create_round(new_issue, action_name, campaign)

        if t.comments - 1 >= 0
          @github.issues.comments.all(:repo => projectname, :user => username, :issue_id => t.number).each do |f|
            new_record = Record.create({
                                           type: 'Note',
                                           description: f.body + '\n' + f.issue_url,
                                           encounter_id: encounter.id,
                                           created_at: f.created_at,
                                           updated_at: f.updated_at,
                                           quest_id: new_issue.id,
                                           group_id: campaign.group_id

                                       })
            create_round(new_record, action_name, campaign)
          end
        end
      end

    end

    return issueobj

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

        unless Record.find_by sha: t["sha"]
          new_commit = Commit.create({encounter_id: encounter.id,
                                      quest_id: campaign.id,
                                      description: t["commit"]["message"],
                                      url: t["html_url"],
                                      group_id: campaign.group_id,
                                      sha: t["sha"]
                                     })

          create_round(new_commit, action_name, campaign)
        end
      end
    end
    return @commits
  end

  # Import a project to QTD
  # Note: this should be run only when first time import is initiated
  def initial_import(username, projectname, group)
    if group.nil?
      group = @user.wrapper_group
    end
    # set import status
    project = GithubRepo.find_by(github_user: username, project_name: projectname, group_id: group.id)

    if project.imported.nil? || !project.imported


      project.imported = 1


      # encounter stop
      if Encounter.last
        Encounter.last.close
      end

      # new encounter
      import_campaign = Campaign.create({name: projectname,
                                         description: "Imported Project for #{projectname}",
                                         group_id: @user.wrapper_group.id,
                                         vcs: true
                                        })
      project.campaign_id =  import_campaign.id
      project.save


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

  def github_update_all_projects(user)
    #get all projects
    @repo_list = list_projects
    @repo_list.each do |t|
      if t.imported?
        update_project(t.github_user, t.project_name)
      end
    end

    #TODO think about if we update project campaing is easily determined as imported campaign, what about encounters???

  end

  # Delete Project From QTD
  # @param username     Github User Name
  # @param projectname  Github Project Name
  def del_project(username, projectname)
    project = GithubRepo.find_by(github_user: username, project_name: projectname, group_id: @user.wrapper_group.id)
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


  # Push Note as comments to Github Issue
  def push_comment(username, projectname, issue_no, comment)
    @github  = github_init(username, projectname)
    @new_comment = @github.issues.comments.create :repo_name=> projectname, :user_name => username , :issue_id => issue_no ,:body => comment
  end

  #Close Issue from a closed quest
  def close_issue(username, projectname, issue_no)
    @github  = github_init(username, projectname)
    @github.issues.edit(:number => issue_no, :state => 'closed')
  end

  #Open Issue from a created quest
  def open_issue(username, projectname, quest)
    @github  = github_init(username, projectname)
    @github.issues.create(
      :title => quest.name,
      :body => quest.description,
      :state => 'open',
      # "assignee" => "octocat",
      # "milestone" => 1,
      :labels => [
        'QTD'
      ]
    )
  end

end
