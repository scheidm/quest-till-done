class Campaign < Quest
  default_scope Campaign.where('campaign_id == id')
end
