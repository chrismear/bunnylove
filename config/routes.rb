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

ActionController::Routing::Routes.draw do |map|
  map.resources "bunnies",
                :new => {:secret => :post},
                :member => {:check => :post}
  map.resources "bunny_sessions"
  map.resources "valentines",
                :collection => {:received_after => :any}
  map.resources "frights",
                :collection => {:received_after => :any}
  map.resources "password_resets",
                :new => {:secret => :post},
                :member => {:check => :post}
  
  map.homepage "/", :controller => "misc", :action => "index"
  map.privacy "/privacy", :controller => "misc", :action => "privacy"
  map.boom "boom", :controller => "misc", :action => "boom"
  
  map.received_bunny_valentines "/bunnies/:bunny_id/valentines/received.:format", :controller => "valentines", :action => "received"
  map.received_bunny_frights "/bunnies/:bunny_id/frights/received.:format", :controller => "frights", :action => "received"
end
