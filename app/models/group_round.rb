##
# An event related to manipulating a record
class GroupRound < Round
  belongs_to :group, foreign_key: "event_id"
end
