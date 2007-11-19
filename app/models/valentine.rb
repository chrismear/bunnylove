class Valentine < ActiveRecord::Base
  belongs_to :sender, :class_name => "Bunny", :foreign_key => :sender_id
  belongs_to :recipient, :class_name => "Bunny", :foreign_key => :recipient_id
  
  validates_presence_of :message, :sender, :recipient
  
  def recipient_username
    self.recipient.username if self.recipient
  end
end
