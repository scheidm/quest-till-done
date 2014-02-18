##
# An event related to manipulating a record
class UserRound < Round
  belongs_to :user, foreign_key: "event_id"
end
