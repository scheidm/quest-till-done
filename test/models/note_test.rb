require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @pomodoro = Pomodoro.create!
    @pomodoro.notes.create(description:"I'm a note!")
  end

  test "can create a note" do
    assert Note.create!
  end
end
