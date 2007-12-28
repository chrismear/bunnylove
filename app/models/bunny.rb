class Bunny < ActiveRecord::Base
  acts_as_authenticated
  
  has_many :sent_valentines, :class_name => "Valentine", :foreign_key => :sender_id, :order => "created_at DESC"
  has_many :received_valentines, :class_name => "Valentine", :foreign_key => :recipient_id, :order => "created_at DESC"
  
  attr_accessor :proto_bunny
  
  attr_protected :proto_bunny, :key, :crypted_password, :salt, :remember_token, :secret
  
  def signed_up?
    !self.secret_confirmed_at.nil?
  end
  
  def generate_secret!
    self.update_attribute(:secret, Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--kwyjibo--")[0..5])
    self.secret
  end
  
  def check_secret!
    if Metachat.check_secret(self.username, self.secret)
      self.update_attribute(:secret_confirmed_at, Time.now.utc)
      true
    else
      false
    end
  end
  
  def self.create_proto_bunny(new_username)
    b = self.new
    b.proto_bunny = true
    b.username = new_username
    if b.save
      b
    else
      nil
    end
  end
  
  def password_required?
    crypted_password.blank? && !self.proto_bunny
  end
  
  def received_valentines_after(valentine_id)
    self.received_valentines.find(:all, :conditions => ["id > ?", valentine_id], :order => "id ASC")
  end
  
  def received_valentines_for_year(year)
    year = year.to_i
    self.received_valentines.find(:all, :conditions => ["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)], :order => "created_at DESC")
  end
  
  def sent_valentines_for_year(year)
    year = year.to_i
    self.sent_valentines.find(:all, :conditions => ["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)], :order => "created_at DESC")
  end
  
  def key
    unless self.read_attribute(:key)
      self.update_attribute(:key, Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--bunnybunnybunny--"))      
    end
    self.read_attribute(:key)
  end
  
  def self.update_by_username_or_new(options={})
    return nil unless options[:username]
    b = self.find(:first, :conditions => ["username = ?", options[:username]])
    if b
      b.attributes = options
    else
      b = self.new(options)
    end
    b
  end
end
