class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
#       This is suppose to be array of friends
       t.timestamps
    end
  end
end
