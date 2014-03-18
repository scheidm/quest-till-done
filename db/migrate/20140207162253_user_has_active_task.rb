class UserHasActiveTask < ActiveRecord::Migration
  def change
    add_column :users, :active_quest, :integer
    add_column :encounters, :user_id, :integer
  end
end
