class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :text
      t.belongs_to :link

      t.timestamps
    end
  end
end
