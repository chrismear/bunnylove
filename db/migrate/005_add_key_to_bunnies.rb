class AddKeyToBunnies < ActiveRecord::Migration
  def self.up
    add_column :bunnies, :key, :string
  end
  
  def self.down
    remove_column :bunnies, :key
  end
end
