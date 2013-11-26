class ChangePomodoroEndTimeField < ActiveRecord::Migration
  def self.up
    change_column :pomodoros, :end_time, :datetime
  end

  def self.down
    change_column :pomodoros, :end_time, :date
  end
end
