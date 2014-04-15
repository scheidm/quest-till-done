# Controller for Record
class SearchesController < ApplicationController

  # Show all search result
  # @return [Html] All result
  def index
    recs=Record.search params[:query], where: {:group_id => @user.wrapper_group.id}
    quests=Quest.search params[:query], where: { :group_id => @user.wrapper_group.id}
    @results = (recs.results + quests.results).paginate page: params[:page], per_page: 10
  end

  # auto complete search for quest
  def quest_autocomplete
    render json: Quest.search(params[:query], where: { :group_id => @user.wrapper_group.id})
  end
end
