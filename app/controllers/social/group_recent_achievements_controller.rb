class Social::GroupRecentAchievementsController < ApplicationController
  def getGroups
    @groups = current_user.getGroups
  end
end
