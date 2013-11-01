require 'test_helper'

class PomodoroTest < ActiveSupport::TestCase
   test "accepts a note" do
     @pomodoro = Pomodoro.create
     @note = Note.create pomodoro: @pomodoro
     @note.save
     @pomodoro.save
     puts @note
     puts @pomodoro.notes
     assert_compare(@pomodoro.notes.length, ">", 0)
   end
end
