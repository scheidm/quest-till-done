class CreateQuest < ActiveRecord::Migration
  def change
    create_table :quests do |t|
	t.string :name, null: false
	t.string :status, :priority
	t.text :description
	t.integer :estimated_cost, :current_cost
	t.integer :parent_id, :campaign_id
	t.date :deadline
	t.belongs_to :user
	t.timestamps
    end
  end
end
