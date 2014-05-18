class ChangeGroupIdForRounds < ActiveRecord::Migration
  def change
    change_column :rounds, :group_id, :integer
  end
end
