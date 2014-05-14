
class ConversationsController < ApplicationController

  helper_method :mailbox, :conversation

  def index
    @conversations = @user.mailbox.inbox.load.sort
  end

  def reply
    @user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to conversation
  end

  def trashbin
    @trash ||= current_user.mailbox.trash.all
  end

  def empty_trash
    @user.mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(:deleted => true)
    end
    redirect_to :conversation
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :back
  end

  def trash
    conversation.move_to_trash(@user)
    redirect_to :back
  end

  # def group_kick
  #   @group = Group.find(params[:id])
  #   if @group.admins.include? @user
  #     @target = User.find( params[:user_id] )
  #     if @group.admins.include? @target
  #       #NOTIFICATION NEEDED
  #     else
  #       @group.users.delete User.find( params[:user_id] )
  #     end
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to group_path(@group), notice: 'Member removed successfully.' }
  #   end
  # end
  #
  # def group_invite
  #   @group = Group.find(params[:id])
  #   user = User.find( params[:user_id] )
  #   unless @group.users.include? user
  #     @group.users.push user
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to group_path(@group), :flash => { :success =>'Member added successfully.' }}
  #   end
  # end
  #
  # def group_promote
  #   @group = Group.find(params[:id])
  #   user = User.find( params[:user_id] )
  #   unless @group.admins.include? user
  #     @group.admins.push user
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to group_path(@group), notice: 'Member promoted successfully.' }
  #   end
  # end

  private

  def mailbox
    @mailbox ||= @user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
        when 0 then self
        when 1 then self[subkeys.first]
        else subkeys.map{|k| self[k] }
      end
    end
  end

end
