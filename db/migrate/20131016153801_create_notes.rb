class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.column :description, :text
      t.timestamps
    end
  end
end
