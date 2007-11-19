class EncodeMessages < ActiveRecord::Migration
  class Valentine < ActiveRecord::Base
    def self.rot13(missive)
      missive.tr "A-Za-z", "N-ZA-Mn-za-m"
    end
  end
  
  def self.up
    Valentine.find(:all).each do |v|
      v.update_attribute(:message, Valentine.rot13(v.message))
    end
  end
  
  def self.down
    Valentine.find(:all).each do |v|
      v.update_attribute(:message, Valentine.rot13(v.message))
    end
  end
end
