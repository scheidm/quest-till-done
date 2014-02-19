class ChangeRecordTypeColName < ActiveRecord::Migration
  def up
    rename_column("records", "type", "record_type")
  end

  def down
    rename_column("records", "record_type", "type")

  end
end
