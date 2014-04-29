class AddGroupToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :group_id, :integer
  end
end
