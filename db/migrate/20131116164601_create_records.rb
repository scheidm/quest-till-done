class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records, as_relation_superclass: true do |t|
      t.string :url

      t.timestamps
    end
  end
end
