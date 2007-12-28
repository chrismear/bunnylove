class Valentine < ActiveRecord::Base
  START_DAY = 1
  START_MONTH = 12
  END_DAY = 31
  END_MONTH = 12
  
  cattr_accessor :start_month, :start_day, :end_day, :end_month
  
  belongs_to :sender, :class_name => "Bunny", :foreign_key => :sender_id
  belongs_to :recipient, :class_name => "Bunny", :foreign_key => :recipient_id
  
  validates_presence_of :message, :sender, :recipient
  
  def recipient_username
    self.recipient.username if self.recipient
  end
  
  def message=(new_message)
    self.write_attribute("message", self.class.rot13(new_message))
  end
  
  def Valentine.rot13(missive)
    if missive.respond_to?(:tr)
      missive.tr "A-Za-z", "N-ZA-Mn-za-m"
    else
      nil
    end
  end
  
  def self.allow_valentines?
    now = Time.now.utc
    start_date = Time.utc(now.year, @@start_month || START_MONTH, @@start_day || START_DAY)
    end_date = Time.utc(now.year, @@end_month || END_MONTH, @@end_day || END_DAY)
    end_date = end_date + 1.day
    now >= start_date && now < end_date
  end
end
