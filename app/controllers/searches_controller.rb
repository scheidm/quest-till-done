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
    render json: Quest.search(params[:query], where: { :user_id => current_user.id})
  end

  # auto complete search for record, quest and campaign
  def all_autocomplete
    quests = Quest.search(params[:query], where: { :user_id => current_user.id})
    recs = Record.search(params[:query], where: { :user_id => current_user.id})
    render json: search_json(quests.results + recs.results)
  end

  private
  def search_json(value)
    list = value.map do |item|
      if Record.child_classes.include? item.class then
        label = item.description.to_s
      else
        label = item.name.to_s
      end
      {
          :label => label,
          :value => item.id.to_s,
          :class => item.class.to_s
      }
    end
    list.to_json
  end
end
