# Based on acts_as_authenticated by Rick Olson.

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

require 'digest/sha1'
module ActiveRecord
  module Acts
    module Authenticated
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_authenticated
          attr_accessor :password
          
          validates_presence_of :username
          validates_presence_of :password, :if => :password_required?
          validates_presence_of :password_confirmation, :if => :password_required?
          validates_length_of :password, :within => 4..40, :if => :password_required?
          validates_confirmation_of :password, :if => :password_required?
          validates_uniqueness_of :username, :case_sensitive => false
          before_save :encrypt_password
          
          include ActiveRecord::Acts::Authenticated::InstanceMethods
          extend ActiveRecord::Acts::Authenticated::SingletonMethods
        end
      end
      
      module SingletonMethods
        # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
        def authenticate(username, password)
          user = find_by_username(username) # need to get the salt
          user && user.authenticated?(password) ? user : nil
        end
        
        # Encrypts some data with the salt.
        def encrypt(password, salt)
          Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        end
      end
      
      module InstanceMethods
        # Encrypts the password with the user salt
        def encrypt(password)
          self.class.encrypt(password, salt)
        end
        
        def authenticated?(password)
          crypted_password == encrypt(password)
        end
        
        def remember_token?
          remember_token_expires_at && Time.now.utc < remember_token_expires_at
        end
        
        # These create and unset the fields required for remembering users between browser closes
        def remember_me
          self.remember_token_expires_at = 2.weeks.from_now.utc
          self.remember_token            = encrypt("#{username}--#{remember_token_expires_at}")
          save(false)
        end
        
        def forget_me
          self.remember_token_expires_at = nil
          self.remember_token            = nil
          save(false)
        end
        
        protected
        
        # before filter
        def encrypt_password
          self.salt = Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--#{username}--") if new_record?
          return if password.blank?
          self.crypted_password = encrypt(password)
        end
        
        def password_required?
          crypted_password.blank? || !password.blank?
        end
      end
    end
  end
end