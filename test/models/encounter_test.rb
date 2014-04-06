require 'test/unit'

class EncounterTest <  ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @encounterA = Encounter.new
    @encounterB = Encounter.find(1)
  end

  test "Encounter created" do
    assert !@encounterA.nil?
  end

  test "Encounter end time is bigger than start time" do
    assert @encounterB.end_time >= @encounterB.created_at
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

end