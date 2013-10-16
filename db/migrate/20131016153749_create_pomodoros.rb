class CreatePomodoros < ActiveRecord::Migration
  def change
    create_table :pomodoros do |t|
      t.date :end_time
      t.timestamps
    end
  end
end
