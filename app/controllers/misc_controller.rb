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

class MiscController < ApplicationController
  def index
    if current_bunny
      if Fright.allow_frights?
        redirect_to(frights_path) and return
      else
        redirect_to(valentines_path) and return
      end
    end
    
    render :action => :index, :layout => 'index'
  end
  
  def privacy
    @site_name = if Fright.allow_frights?
      "Bunny <s>Love</s> Fright"
    else
      "Bunny Love"
    end
  end
  
  def boom
    raise "Boom!"
  end
end
