class CreateBunnies < ActiveRecord::Migration
  def self.up
    create_table :bunnies do |t|
      t.column :username, :string
      t.column "crypted_password",          :string,   :limit => 40
      t.column "salt",                      :string,   :limit => 40
      t.column "created_at",                :datetime
      t.column "updated_at",                :datetime
      t.column "remember_token",            :string
      t.column "remember_token_expires_at", :datetime
      t.column "secret", :string
    end
  end
  
  def self.down
    drop_table :bunnies
  end
end
