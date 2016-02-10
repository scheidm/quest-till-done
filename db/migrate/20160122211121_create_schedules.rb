class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.json "schedule_dump"
      t.string   "related_type"
      t.integer  "related_id"

      t.timestamps
    end
  end
end
