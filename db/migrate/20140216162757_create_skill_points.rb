class CreateSkillPoints < ActiveRecord::Migration
  def change
    create_table :skill_points do |t|

      t.timestamps
    end
  end
end
