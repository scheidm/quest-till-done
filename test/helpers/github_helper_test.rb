require 'test/unit'

class GithubHelperTest < ActionView::TestCase
  include GithubHelper
  include RoundHelper
  include TimerHelper


  def setup
    login
    @encounter = Encounter.first
    @campaign = Campaign.first
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # login should work if they have correct information
  test 'Login should be success with access token' do
    assert_nothing_raised (RuntimeError) {
       login
    }
  end

  # List Projects
  test 'Projects listing wont be empty' do
    project_hash = list_projects
    assert project_hash.length > 0
  end

  # List Branches
  test 'Branches listing for a project' do
    branches_hash = list_branches('scheidm', 'quest-till-done')
    assert branches_hash.length > 0
  end

  # # List issues
  # test 'Issues Listing' do
  #   issue_list = list_issues('scheidm', 'quest-till-done', @encounter, @campaign)
  #   assert_nothing_raised() {
  #     assert issue_list.length > 0
  #   }
  # end
  #
  # # List Commits
  # test 'Commits Listing wont be empty' do
  #   commits_list = list_commits('scheidm', 'quest-till-done', @encounter, @campaign)
  #   assert_nothing_raised() {
  #     assert commits_list.length > 0
  #   }
  #
  # end




  def current_user
    User.find(3)
  end
end