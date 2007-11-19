require 'net/http'
require 'uri'

class Bunny < ActiveRecord::Base
  acts_as_authenticated
  
  has_many :sent_valentines, :class_name => "Valentine", :foreign_key => :sender_id, :order => "created_at DESC"
  has_many :received_valentines, :class_name => "Valentine", :foreign_key => :recipient_id, :order => "created_at DESC"
  
  def signed_up?
    !self.secret_confirmed_at.nil?
  end
  
  def generate_secret!
    self.update_attribute(:secret, Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--kwyjibo--")[0..5])
    self.secret
  end
  
  def check_secret!
    response = Net::HTTP.get_response(URI.parse("http://metachat.org/users/#{self.username}"))
    
    if Metachat.check_secret(self.username, self.secret)
      self.update_attribute(:secret_confirmed_at, Time.now.utc)
      true
    else
      false
    end
  end
end
