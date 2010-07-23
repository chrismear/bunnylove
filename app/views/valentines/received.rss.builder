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

xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("My Bunny Love Valentines")
    xml.link(valentines_url)
      @received_valentines.each do |valentine|
        xml.item do
          xml.title(truncate(decode_message(valentine.message)))
          xml.description(decode_message(valentine.message))
          xml.pubDate(valentine.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link(valentines_url(:anchor => "received_valentine_#{valentine.id}"))
        end
      end
  }
}
