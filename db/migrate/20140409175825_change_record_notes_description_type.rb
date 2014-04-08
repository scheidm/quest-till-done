class ChangeRecordNotesDescriptionType < ActiveRecord::Migration
  def change
    change_column :records, :description, :text
  end
end
