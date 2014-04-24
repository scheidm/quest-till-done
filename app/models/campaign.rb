# single table inheritance with the Quest model. That is, a Campaign is largely
# a scope on quest, a Quest.where('campaign_id = NULL')
class Campaign < Quest
  # Limit default scope so that campaign_id always equal to it's id
  has_many :quests
  has_many :rounds
  scope :search_import, -> { includes(:records, :quests) }

  #Will generate a float value representing the completion percentage of the
  #given campaign, for display on the campaign show page.
  def progress
    Float(self.quests.where('status = (?)',"Closed").count)/Float(self.quests.count)*100 
  end

  #Will define additional relational data for the purpose of deep searching, as
  #specified through the searchkick gem
  def search_data
    attributes.merge(
      records: self.records.map(&:description),
      notes: self.notes.map(&:description),
      quotes: self.links.map(&:quote),
      sites: self.links.map(&:url),
    )
  end

  #Will define the link generated in the timeline when interacting with this
  #model.
  def to_link
    '/campaigns/' + self.id.to_s
  end
end
