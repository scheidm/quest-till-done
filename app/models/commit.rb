class Commit < Record
  # Validate presence of description and url
  validates_presence_of :description, :url, :allow_blank => false
  belongs_to :quest
  attr_accessor :questname

  def self.model_name
    Record.model_name
  end

  def name
    if self.quest_id.nil?
      Quest.last.name
    else
      self.quest_id = Quest.find_by_name(name).id
      Quest.find(self.quest_id).name
    end

  end

  def name=(name)
    self.quest_id = Quest.find_by_name(name).id
    Quest.find(self.quest_id).name = name

  end
end