class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.timestamps
    end
    create_table :users_groups, id: false do |t|
      t.belongs_to :user
      t.belongs_to :group
    end
  end
end
