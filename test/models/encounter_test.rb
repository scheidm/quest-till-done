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
    assert !@encounterA.nil?
  end

  test "Encounter end time is bigger than start time" do
    assert @encounter1.end_time >= @encounter1.created_at
  end


end