# Class for getting friends from a user
class FriendController < ApplicationController

  # Get Friends detail
  # @return [Html] Friends detail by current user id
  def getFriends
    @friends=Friend.find(:user_id=>current_user)
  end

  # Add a new Friend
  # @param [Friend] friendName
  def add(friendName)

  end

  # Remove a friend
  # @param [Friend] friendName
  def delete(friendName)

  end




end
