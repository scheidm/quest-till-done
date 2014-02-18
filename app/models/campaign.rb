# Campaigns model for a project
class Campaign < Quest
  # Limit default scope so that campaign_id always equal to it's id
  has_many :quests
  default_scope Campaign.where('campaign_id == id')


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
