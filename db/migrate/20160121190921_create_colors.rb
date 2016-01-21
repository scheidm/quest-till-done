class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string   "type"
      t.integer  "related_id"
      t.string   "color_hex"

      t.timestamps
    end
  end
end
