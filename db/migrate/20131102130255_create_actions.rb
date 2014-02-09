class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.string :status
      t.text :description
      t.integer :estimated_cost
      t.integer :current_cost
      t.date :deadline
      t.string :priority
      t.integer :parent_id

      t.timestamps
    end
  end
end
