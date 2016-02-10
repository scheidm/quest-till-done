# Controller for Record
class SearchesController < ApplicationController

  # Show all search result
  # @return [Html] All result
  def index
    if params.has_key? 'type'
      if(params[:type] != 'All' && is_valid_model(params[:type]))
        model = params[:type].constantize
      end
    end
    archive=0
    archive=1 if(params.has_key? 'inc_archive')
    @type = 'All'
    @record_type = 'All'
    @results = get_search_result(model, params[:query], archive).paginate page: params[:page], per_page: 10
  end

  # auto complete search for quest
  def quest_autocomplete
    render json: Quest.search(params[:query], where: { :group_id => @user.wrapper_group.id})
  end

  # auto complete search for record, quest and campaign
  def all_autocomplete
    quests = Quest.search(params[:query], where: { :group_id => @user.wrapper_group.id})
    recs = Record.search(params[:query], where: { :group_id => @user.wrapper_group.id})
    render json: search_json(quests.results + recs.results)
  end

  # autocomplete for user
  def user_autocomplete
    render json: User.all.reject{ |u| u == @user }
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

  def get_search_result(model, query, include_archive)
    whash={ :group_id => @user.wrapper_group.id}
    if include_archive==0
      whash[:status]={ :not  => ["Archived", "Closed"]}
    end
    if model.nil?
      quests = Quest.search(query, where: whash)
      recs = Record.search(query, where: { :group_id => @user.wrapper_group.id})
      results = quests.results + recs.results
      @type = 'All'
    elsif (model == Record || Record.child_classes.include?(model))
      results = model.search(query, where: whash).results
      @type = 'Record'
      @record_type = (model == Record)? 'All': model.to_s
    elsif model == Campaign
      results = Campaign.search(query, where: whash).results
      @type = 'Campaign'
    elsif model == Quest
      whash[:campaign_id]={ :not => nil}
      results = Quest.search(query, where: whash ).results
      @type = 'Quest'
    else
      results = []
      @type = 'All'
    end
    return results
  end

  def is_valid_model(model)
    valid = [Record.to_s, Campaign.to_s, Quest.to_s]
    valid.concat Record.child_classes.collect{|i| i.to_s}
    if(valid.include? model)
      return true
    else
      return false
    end
  end
end
