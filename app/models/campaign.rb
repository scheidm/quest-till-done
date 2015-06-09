# single table inheritance with the Quest model. That is, a Campaign is largely
# a scope on quest, a Quest.where('campaign_id = NULL')
require 'digest/md5'
class Campaign < Quest
  # Limit default scope so that campaign_id always equal to it's id
  has_many :quests,  :dependent => :destroy
  has_many :rounds,  :dependent => :destroy
  scope :search_import, -> { includes(:records, :quests) }
  before_destroy :delete_related
  def delete_related
  end

  def color
    d=Digest::MD5.hexdigest(self.name)
    x=(Integer("0x#{d}")& 0xCCCCCC)
    y= sprintf("%06x",x)
    return y
  end

  def progress
    Float(self.quests.where('status = (?)',"Closed").count)/Float(self.quests.count)*100 
  end

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
    Encounter.where('id in (?)',self.rounds.pluck(:encounter_id))
  end

  def age
    lapsed=Time.now-self.updated_at
    if(lapsed < 1.day)
      return "live"
    elsif(lapsed < 1.week)
      return "fresh"
    elsif(lapsed < 1.month)
      return "semi-fresh"
    elsif(lapsed < 3.month)
      return "semi-stale"
    elsif(lapsed < 6.months)
      return "very-stale"
    else
      return "dead"
    end
  end

  def to_link
    '/campaigns/' + self.id.to_s
  end
end
