class QuestRound < Round
  belongs_to :quest, foreign_key: "event_id"
end
