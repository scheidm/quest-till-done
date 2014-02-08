class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.integer :user_id
      t.integer :setting_time
      t.integer :current_time
      t.boolean :enabled

      t.timestamps
    end
  end
end
