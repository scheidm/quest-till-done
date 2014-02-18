# Campaigns model for a project
class Campaign < Quest
  # Limit default scope so that campaign_id always equal to it's id
  has_many :quests
  default_scope Campaign.where('campaign_id == id')
end
