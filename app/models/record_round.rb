##
# An event related to manipulating a group
class GroupRound < Round
  belongs_to :group, foreign_key: "event_id"
end
