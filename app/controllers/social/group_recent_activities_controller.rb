class Social::GroupRecentActivitiesController < ApplicationController
  def getGroups
    @groups = current_user.getGroups
  end
end
