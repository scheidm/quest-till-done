class AddAttachmentCodeToImages < ActiveRecord::Migration
  def self.up
    change_table :records do |t|
      t.attachment :code
    end
  end

  def self.down
    drop_attached_file :records, :code
  end
end
