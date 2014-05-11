##
# An event related to manipulating a record
class RecordRound < Round
  belongs_to :record, foreign_key: "event_id"
end
