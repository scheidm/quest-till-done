class GithubRepo < ActiveRecord::Base
  belongs_to :user

  #Will define the link generated in the timeline when interacting with this
  #model.
  def to_link
    return '#'
  end
end
