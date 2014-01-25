class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string   :type
      t.integer  :pomodoro_id
      t.text     :description, null:false
      t.string   :url
      t.timestamps
    end
  end
end
