class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string   :type
      t.text     :description, null:false
      t.string   :url
      t.belongs_to :encounter
      t.timestamps
    end
  end
end
