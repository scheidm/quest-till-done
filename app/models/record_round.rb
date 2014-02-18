class RecordRound < Round
  belongs_to :record, foreign_key: "event_id"
end
