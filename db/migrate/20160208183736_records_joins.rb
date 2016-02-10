class RecordsJoins < ActiveRecord::Migration
  def change
    create_table :groups_records, id: false do |t|
      t.belongs_to :group
      t.belongs_to :record
    end
    create_table :quests_records, id: false do |t|
      t.belongs_to :quest
      t.belongs_to :record
    end
  end
end
