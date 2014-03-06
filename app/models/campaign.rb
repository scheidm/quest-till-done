# Campaigns model storing the root task in a project. The class is defined with
# single table inheritance with the Quest model. That is, a Campaign is largely
# a scope on quest, a Quest.where('campaign_id = NULL')
class Campaign < Quest
  # Limit default scope so that campaign_id always equal to it's id
  has_many :quests
  scope :search_import, -> { includes(:records, :quests) }

  def search_data
    attributes.merge(
      records: self.records.map(&:description),
      notes: self.notes.map(&:description),
      quotes: self.links.map(&:quote),
      sites: self.links.map(&:url),
    )
  end

  # Generates a paginated collection encounters for the campaign
  # @param end_time [datetime] last time included in list of encounters
  # end_time defaults to the current time.
  # @return [collection] first page of encounters preceeding end_time
  # 
  def timeline( end_time=Time.now )
    rounds=Rounds.where('campaign_id = (?)',self.id).where('created_at <= (?)', end_time).order(created_at: :desc).pluck(:encounter_id)
    Encounter.where('id in (?)',rounds)
  end
end
