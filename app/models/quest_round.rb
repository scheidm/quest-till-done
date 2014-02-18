##
# An event related to manipulating a quest
class QuestRound < Round
  belongs_to :quest, foreign_key: "event_id"
end
