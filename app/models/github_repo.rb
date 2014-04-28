class GithubRepo < ActiveRecord::Base
  belongs_to :group

  def to_link
    return '#'
  end
end
