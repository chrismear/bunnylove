class AddSecurityAttributesToBunnies < ActiveRecord::Migration
  def self.up
    add_column :bunnies, :secret_confirmed_at, :timestamp
  end

  def self.down
    remove_column :bunnies, :secret_confirmed_at
  end
end
