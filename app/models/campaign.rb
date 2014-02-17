class Campaign < Quest
  has_many :quests
  default_scope Campaign.where('campaign_id == id')
end
