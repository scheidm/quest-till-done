require 'test_helper'

class PomodoroTest < ActiveSupport::TestCase
   test "accepts a note" do
     @pomodoro = Pomodoro.create!
     @pomodoro.notes.create(description: "hello world")
     refute @pomodoro.notes.empty?
   end
end
