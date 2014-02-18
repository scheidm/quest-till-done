# Avatar controller class
class User::AvatarsController < ApplicationController

  # define avatar by default value
  # @return [Binary] image file
  def show

  end

  # destroy avatar
  def destroy
    @user = current_user
    @user.remove_avatar!

    @user.save
    @user.reset_events_cache

    redirect_to profile_path
  end
end
