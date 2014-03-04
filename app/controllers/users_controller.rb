class UsersController < ApplicationController
  def index

  end
  def getFriends
    @friends = current_user.getFriends
  end
  def getGroups
    @groups = current_user.getGroups
  end
  # define avatar by default value
  # @return [Binary] image file
  def show_avatar

  end

  # destroy avatar
  def destroy_avatar
    @user = current_user
    @user.remove_avatar!

    @user.save
    @user.reset_events_cache

    redirect_to profile_path
  end
end
