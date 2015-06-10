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

  def to_json
    return {:id   => self.id, 
            :attr => { 
                     :name        =>  self.name, 
                     :description =>  self.description,
                     :url         => '/campaigns/' +  self.id.to_s, 
                     :status      =>  self.status
                     }
            }
  end 
  
  def to_td_json
    number_of_days = 7
    data = nil
    0.upto(number_of_days) {|number|
      ring = {:id => "#{number}_days_#{self.id}"}
      ring[:children] = children = []
      if !data.nil?
        children << data
      else
        json=self.to_json
        json[:attr][:color]='#AF4D43'
        children << json
      end
      if number != 0
        count = 0
        self.quests.where("deadline >= ? and deadline < ?", (number-1).days.from_now, number.days.from_now).where("status != 'Closed'").each {|quest|
          color = '#29AB87'
          radius = 45;
          if quest.importance then
            color = '#0A6F75'
            radius = 60;
          end
          children << {:id => quest.id, :attr => { :name => quest.name, :description => quest.description, :url => '/quests/' + quest.id.to_s, :status => quest.status, :color => color, :radius => radius}}
          count+=1
        }
        ring[:attr] = {:name => "#{number} Days", :description => "#{count} quests pending", :url => '#'}
      else
        ring[:attr] = {:name => "Campaign", :description => self.description, :url => '#'}
      end
      data = ring
    }
    return data
  end
end
