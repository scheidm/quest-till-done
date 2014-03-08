# Controller for Record
class SearchesController < ApplicationController

  # Show all search result
  # @return [Html] All result
  def index
    recs=Record.search params[:query]
    quests=Quest.search params[:query]
    @results = (recs.results + quests.results).paginate page: params[:page], per_page: 10
    s = quests.size
    v = s
  end

  # auto complete search for quest
  def quest_autocomplete
    render json:  Quest.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end
end
