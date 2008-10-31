class CreateFrights < ActiveRecord::Migration
  def self.up
    create_table :frights do |t|
      t.integer  "sender_id"
      t.integer  "recipient_id"
      t.text     "message"
      t.datetime "created_at"
    end
  end

  def self.down
    drop_table :frights
  end
end
