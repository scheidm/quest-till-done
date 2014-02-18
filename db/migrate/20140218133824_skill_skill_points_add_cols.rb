class SkillSkillPointsAddCols < ActiveRecord::Migration
  def up
    #no array here
    add_column :skills, :achievements, :string
    add_column :skills, :description, :string
    add_column :skill_points, :level, :integer
    add_column :skill_points, :exp, :integer
    add_column :users, :level, :integer
    add_column :users, :exp, :integer
  end

  def down

  end
end
