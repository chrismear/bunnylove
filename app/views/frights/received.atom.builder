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

atom_feed(:schema_date => "2008") do |feed|
  feed.title("My Bunny Frights")
  feed.update(@received_frights.empty? ? Time.now.utc : @received_frights.first.created_at)
  @received_frights.each do |fright|
    feed.entry(fright, :url => frights_url(:anchor => "received_fright_#{fright.id}")) do |entry|
      entry.title(truncate(decode_message(fright.message)))
      entry.content(decode_message(fright.message))
    end
  end
end
