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
