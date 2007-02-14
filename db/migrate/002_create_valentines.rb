class CreateValentines < ActiveRecord::Migration
  def self.up
    create_table :valentines do |t|
      t.column "sender_id", :integer
      t.column "recipient_id", :integer
      t.column "message", :text
      t.column "created_at", :timestamp
    end
  end
  
  def self.down
    drop_table :valentines
  end
end
