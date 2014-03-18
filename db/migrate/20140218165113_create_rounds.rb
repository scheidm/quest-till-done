class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :type
      t.integer :event_id
      t.string :event_description
      t.belongs_to :encounter
      t.timestamps
    end
  end
end
