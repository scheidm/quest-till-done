class AddTimerStateColumn < ActiveRecord::Migration
  def change
	add_column :timers, :state, :bool
  end
end
