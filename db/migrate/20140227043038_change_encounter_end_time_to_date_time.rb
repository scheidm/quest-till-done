class ChangeEncounterEndTimeToDateTime < ActiveRecord::Migration
  def change
	change_column :encounters, :end_time, :datetime
  end
end
