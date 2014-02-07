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

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def standard_flashes(default_message = nil)
    output = ""
    [:notice, :success, :error].each do |flash_type|
      output += "<p class=\"#{h(flash_type)}Message\">#{h(flash[flash_type])}</p>" if flash[flash_type]
    end
    
    if output == "" && default_message
      output = "<p>#{h(default_message)}</p>"
    end
    
    output.html_safe
  end
  
  def error_messages_for(object)
    object = instance_variable_get("@#{object}") if object.is_a? Symbol
    if object && object.errors.count != 0
      error_messages = object.errors.full_messages.map {|msg| content_tag(:li, msg) }
      content_tag("ul", error_messages, :class => "error_messages")
    end
  end
  
  def decode_message(message)
    Valentine.rot13(message)
  end
  
  def htmlize_linebreaks(message)
    h(message).gsub(/\n/, "<br />").html_safe
  end
  
  def current_year
    Time.now.utc.year
  end
  
  def previous_valentines_years
    years = []
    (current_year - 1).downto(2007){|y| years.push(y)}
    years
  end
  
  def previous_frights_years
    years = []
    (current_year - 1).downto(2008){|y| years.push(y)}
    years
  end
end
