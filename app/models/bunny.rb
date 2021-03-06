# Copyright 2007, 2008, 2009, 2010, 2013 Chris Mear
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

class Bunny < ActiveRecord::Base
  acts_as_authenticated
  
  has_many :sent_valentines, :class_name => "Valentine", :foreign_key => :sender_id, :order => "valentines.created_at DESC"
  has_many :received_valentines, :class_name => "Valentine", :foreign_key => :recipient_id, :order => "created_at DESC"
  
  has_many :sent_frights, :class_name => "Fright", :foreign_key => :sender_id, :order => "frights.created_at DESC"
  has_many :received_frights, :class_name => "Fright", :foreign_key => :recipient_id, :order => "created_at DESC"
  
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
  
  def received_valentines_after(valentine_id, year=nil)
    if year
      self.received_valentines.where(["id > ? AND created_at >= ?", valentine_id, Time.utc(year, 1, 1)]).except(:order).order(:id)
    else
      self.received_valentines.where(["id > ?", valentine_id]).except(:order).order(:id)
    end
  end
  
  def received_valentines_for_year(year)
    year = year.to_i
    self.received_valentines.where(["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).order("created_at DESC")
  end
  
  def count_received_valentines_for_year(year)
    year = year.to_i
    self.received_valentines.where(["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).count
  end
  
  def sent_valentines_for_year(year)
    year = year.to_i
    self.sent_valentines.where(["valentines.created_at >= ? AND valentines.created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).order("valentines.created_at DESC").includes(:recipient)
  end
  
  def count_sent_valentines_for_year(year)
    year = year.to_i
    self.sent_valentines.where(["valentines.created_at >= ? AND valentines.created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).count
  end
  
  def received_frights_after(fright_id, year=nil)
    if year
      self.received_frights.where(["id > ? AND created_at >= ?", fright_id, Time.utc(year, 1, 1)]).except(:order).order("id ASC")
    else
      self.received_frights.where(["id > ?", fright_id]).except(:order).order("id ASC")
    end
  end
  
  def received_frights_for_year(year)
    year = year.to_i
    self.received_frights.where(["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).order("created_at DESC")
  end
  
  def count_received_frights_for_year(year)
    year = year.to_i
    self.received_frights.where(["created_at >= ? AND created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).count
  end
  
  def sent_frights_for_year(year)
    year = year.to_i
    self.sent_frights.where(["frights.created_at >= ? AND frights.created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).order("frights.created_at DESC").includes(:recipient)
  end
  
  def count_sent_frights_for_year(year)
    year = year.to_i
    self.sent_frights.where(["frights.created_at >= ? AND frights.created_at < ?", Time.utc(year, 1, 1), Time.utc(year+1, 1, 1)]).count
  end
  
  
  def key
    unless self.read_attribute(:key)
      self.update_attribute(:key, Digest::SHA1.hexdigest("#{object_id}#{rand(255)}#{Time.now.utc.to_s}--bunnybunnybunny--"))      
    end
    self.read_attribute(:key)
  end
  
  def self.update_by_username_or_new(options={})
    return nil unless options[:username]
    b = self.where(["username = ?", options[:username]]).first
    if b
      b.attributes = options
    else
      b = self.new(options)
    end
    b
  end
end
