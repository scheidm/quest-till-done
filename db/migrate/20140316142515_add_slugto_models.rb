class AddSlugtoModels < ActiveRecord::Migration
  def change
    add_column :records, :slug, :string
    add_index :records, :slug
    add_column :quests, :slug, :string
    add_index :quests, :slug
  end
end
