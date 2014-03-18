class GithubRepo < ActiveRecord::Base
  belongs_to :user

  def to_link
    return '#'
  end
end
