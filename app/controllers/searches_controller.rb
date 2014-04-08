# Controller for Record
class SearchesController < ApplicationController

  # Show all search result
  # @return [Html] All result
  def index
    recs=Record.search params[:query], where: {:user_id => current_user.id}
    quests=Quest.search params[:query], where: { :user_id => current_user.id}
    @results = (recs.results + quests.results).paginate page: params[:page], per_page: 10
  end

  # auto complete search for quest
  def quest_autocomplete
    quest = Quest.search params[:query], where: { :user_id => current_user.id}
    render json:  quest #Quest.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end
end
