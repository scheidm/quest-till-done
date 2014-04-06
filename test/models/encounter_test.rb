require 'test/unit'

class EncounterTest <  ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @encounter = Encounter.create(:user_id => 1)
    @encounter1 = Encounter.find(1)
    @encounter2 = Encounter.find(2)

  end


  test "Encounter created" do
    assert !@encounter.nil?
  end

  test "Encounter end time is bigger than start time" do
    assert_not_equal(@encounter2.end_time, @encounter2.created_at, 'Start and end time for encounters should not be the same')
  end




end