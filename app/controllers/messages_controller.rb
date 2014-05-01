class MessagesController < ApplicationController

  # GET /message/new
  def new
    @user = User.find(params[:user])
    @message = @user.messages.new
  end

  # POST /message/create
  def create
    @recipient = User.find(params[:user])
    current_user.send_message(@recipient, params[:body], params[:subject])
    flash[:notice] = "Message has been sent!"
    redirect_to :conversations
  end

  def quest_params
    params.require(:quest).permit(:user, :body, :subject)
  end

end