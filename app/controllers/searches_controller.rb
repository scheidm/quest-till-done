# Controller for Record
class SearchesController < ApplicationController

  # Show all search result
  # @return [Html] All result
  def index
    if params.has_key? 'type'
      if(params[:type] != 'All' && Search.is_valid_model(params[:type]))
        model = params[:type].constantize
      end
    end
    archive=0
    archive=1 if(params.has_key? 'inc_archive')
    @type = 'All'
    @record_type = 'All'
    @results = Search.get_results( @user.wrapper_group.id, model, params[:query], archive).paginate page: params[:page], per_page: 10
  end

  # auto complete search for quest
  def quest_autocomplete
    render json: Quest.search(params[:query], where: { :group_id => @user.wrapper_group.id})
  end

  # auto complete search for record, quest and campaign
  def all_autocomplete
    quests = Quest.search(params[:query], where: { :group_id => @user.wrapper_group.id})
    recs = Record.search(params[:query], where: { :group_id => @user.wrapper_group.id})
    render json: Search.json(quests.results + recs.results)
  end

  # autocomplete for user
  def user_autocomplete
    render json: User.all.reject{ |u| u == @user }
  end

end
