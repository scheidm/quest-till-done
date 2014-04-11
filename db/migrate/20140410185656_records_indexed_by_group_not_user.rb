class RecordsIndexedByGroupNotUser < ActiveRecord::Migration
  def change
    rename_column :records, :user_id, :group_id
  end
end
