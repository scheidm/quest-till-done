class AddTimerAutoMode < ActiveRecord::Migration
  def change
	add_column :timers, :mode, :string 
  end
end
