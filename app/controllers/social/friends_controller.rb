class Social::FriendsController < ApplicationController
  #TODO
  # friends table
  # Add user to get friend method in user

  def getFriends
    @friends = current_user.getFriends
  end

  def index

  end
end
