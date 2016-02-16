class Search
  def self.get_results( group_id, model, query, include_archive)
    whash={ :group_id => group_id}
    rhash={ :group_id => group_id}
    if include_archive==0
      whash[:status]={ :not  => ["Archived", "Closed"]}
    end
    if model.nil?
      quests = Quest.search(query, where: whash)
      recs = Record.search(query, where: rhash)
      results = quests.results + recs.results
      @type = 'All'
    elsif (model == Record || Record.child_classes.include?(model))
      results = model.search(query, where: rhash).results
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
  def self.json(value)
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

  def self.is_valid_model(model)
    valid = [Record.to_s, Campaign.to_s, Quest.to_s]
    valid.concat Record.child_classes.collect{|i| i.to_s}
    if(valid.include? model)
      return true
    else
      return false
    end
  end
end
