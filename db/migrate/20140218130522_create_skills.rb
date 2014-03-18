class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|

      t.timestamps
    end
  end
end
