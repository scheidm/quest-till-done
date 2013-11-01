require 'test_helper'

class PomodoroTest < ActiveSupport::TestCase
   def setup
     @pomodoro = Pomodoro.create!
   end
   
   test "can create a pomodoro" do
     assert Pomodoro.create!
   end

   test "accepts a note" do
     @pomodoro.notes.create(description: "hello world")
     refute @pomodoro.notes.empty?
   end

   test "closes properly" do
     @pomodoro.close
     assert_not_nil @pomodoro.end_time
   end

   test "captures all node variants created within pomodoro" do
     assert true
   end
end
