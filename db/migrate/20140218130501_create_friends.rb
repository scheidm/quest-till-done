class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.user_id
      t.friends
      t.timestamps
    end
  end
end
