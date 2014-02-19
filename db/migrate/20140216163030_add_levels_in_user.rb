class AddLevelsInUser < ActiveRecord::Migration
  def up
    add_column(:users, "adventure_level", :integer)
    add_column(:users, "recent_level", :integer)
    add_column(:users, "achievements", :text)
  end

  def down
    remove_column(:users, :adventure_level)
    remove_column(:users, :recent_level)
    remove_column(:users, :achievements)
  end
end
