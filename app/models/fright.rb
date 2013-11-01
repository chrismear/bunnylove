# Copyright 2007, 2008, 2009, 2010 Chris Mear
# 
# This file is part of Bunnylove.
# 
# Bunnylove is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Bunnylove is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with Bunnylove.  If not, see <http://www.gnu.org/licenses/>.

class Fright < ActiveRecord::Base
  START_DAY = 31
  START_MONTH = 10
  END_DAY = 4
  END_MONTH = 11
  
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
  
  def self.rot13(missive)
    if missive.respond_to?(:tr)
      missive.tr "A-Za-z", "N-ZA-Mn-za-m"
    else
      nil
    end
  end
  
  def self.allow_frights?(now = Time.now.utc)
    start_date = Time.utc(now.year, @@start_month || START_MONTH, @@start_day || START_DAY)
    end_date = Time.utc(now.year, @@end_month || END_MONTH, @@end_day || END_DAY)
    end_date = end_date + 1.day
    now >= start_date && now < end_date
  end
  
  def self.before_halloween?(now = Time.now.utc)
    start_date = Time.utc(now.year, @@start_month || START_MONTH, @@start_day || START_DAY)
    now < start_date
  end
  
  def self.after_halloween?(now = Time.now.utc)
    end_date = Time.utc(now.year, @@end_month || END_MONTH, @@end_day || END_DAY)
    end_date = end_date + 1.day
    now >= end_date
  end
end
