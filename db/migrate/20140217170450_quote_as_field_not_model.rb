class QuoteAsFieldNotModel < ActiveRecord::Migration
  def up
    drop_table :quotes
    add_column :records, :quote, :text
  end
  def down
    create_table "quotes", force: true do |t|
      t.text     "text"
      t.integer  "record_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
