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

require 'acts_as_authenticated'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Authenticated)

Time::DATE_FORMATS[:full] = "%d %B %Y"
Time::DATE_FORMATS[:dmy] = "%d/%m/%Y"
Time::DATE_FORMATS[:short_timestamp] = "at %I:%M %p on %d %B, %Y"

Date::DATE_FORMATS[:full] = "%d %B %Y"
Date::DATE_FORMATS[:dmy] = "%d/%m/%Y"

Bunnylove::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Bunny Love] ",
  :sender_address => %{"Application Error" <notifier@bunnylove.org.uk>},
  :exception_recipients => %w{chris@feedmechocolate.com}
