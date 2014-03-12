class CreateUserConfigs < ActiveRecord::Migration
  def change
    create_table :user_configs do |t|
      t.belongs_to :user
      t.string :timezone_name
      t.boolean :auto_timer
      t.integer :utc_time_offset
      t.integer :encounter_duration
      t.integer :short_break_duration
      t.integer :extended_break_duration

      t.timestamps
    end
  end
end
