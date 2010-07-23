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
  feed.title("My Bunny Love Valentines")
  feed.update(@received_valentines.empty? ? Time.now.utc : @received_valentines.first.created_at)
  @received_valentines.each do |valentine|
    feed.entry(valentine, :url => valentines_url(:anchor => "received_valentine_#{valentine.id}")) do |entry|
      entry.title(truncate(decode_message(valentine.message)))
      entry.content(decode_message(valentine.message))
    end
  end
end
