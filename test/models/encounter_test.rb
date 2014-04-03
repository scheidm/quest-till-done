require 'test/unit'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @encounter1 = Encounter.find(1)
    @encounter2 = Encounter.find(2)

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail

    fail('Not implemented')
  end

  test "Encounter created" do
    assert !@encounter.nil?
  end

  test "Encounter end time is bigger than start time" do
    assert @encounter2.end_time >= @encounter2.created_at
  end

  #TODO Test on Associations, needs more fixtures on other data types



end