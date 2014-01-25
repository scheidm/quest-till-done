class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.date :end_time
      t.timestamps
    end
  end
end
