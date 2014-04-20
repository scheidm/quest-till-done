class AddEncounterRestFlag < ActiveRecord::Migration
  def change
	add_column :encounters, :break_flag, :boolean
  end
end
