class RenameRecordTypeToType < ActiveRecord::Migration
  def change
	rename_column :records, :record_type, :type
  end
end
