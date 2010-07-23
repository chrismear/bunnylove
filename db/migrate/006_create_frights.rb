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

class CreateFrights < ActiveRecord::Migration
  def self.up
    create_table :frights do |t|
      t.integer  "sender_id"
      t.integer  "recipient_id"
      t.text     "message"
      t.datetime "created_at"
    end
  end

  def self.down
    drop_table :frights
  end
end
