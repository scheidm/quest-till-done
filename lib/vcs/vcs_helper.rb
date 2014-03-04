# Module to handle VCS
require 'GitHub_API'
module VcsHelper

  # Handles OAuth login for VCS Integration using User's credentials
  def login
    @github = Github.new client_id: '264a6e1edf1194e61237', client_secret: '4a89a92ea733e1b2e25788f452a4f05692ace995'
  end

  # Fetch latest from the VCS using User's credential
  # @return [JSON] fetched updates information in JSON format
  def fetch
    @githubGithub.new
  end

  # Parse JSON formatted data into QTD recognizable JSON
  # @param data [JSON] vcs JSON formatted data
  # @return [JSON] QTD recognizable QTD JSON format
  def parse

  end

  # Store QTD recognizable JSON to the database
  # @param data [JSON] QTD recognizable JSON format
  def Store

  end
end