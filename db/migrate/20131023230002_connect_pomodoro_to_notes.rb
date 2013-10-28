class ConnectPomodoroToNotes < ActiveRecord::Migration
  def up
    drop_table :nodes
    drop_table :notes
    create_table :nodes do |t|
      t.integer :pomodoro_id

      t.timestamps
    end
    create_table :notes do |t|
      t.text :description
      t.integer :pomodoro_id
      t.timestamps
    end
  end

  def down
    drop_table :nodes
    drop_table :notes
    create_table :nodes do |t|

      t.timestamps
    end
    create_table :notes do |t|
      t.text :description, :text
      t.timestamps
    end
  end
end
