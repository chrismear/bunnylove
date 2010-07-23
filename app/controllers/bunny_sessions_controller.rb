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

class BunnySessionsController < ApplicationController
  def new
  end
  
  def create
    self.current_bunny = Bunny.authenticate(params[:username], params[:password])
    if current_bunny
      if Fright.allow_frights?
        redirect_back_or_default(frights_path)
      else
        redirect_back_or_default(valentines_path)
      end
    else
      flash[:error] = "We couldn't find those details. Please try again."
      render(:action => :new)
    end
  end
  
  def destroy
    self.current_bunny.forget_me if bunny_logged_in?
    cookies.delete :bunny_auth_token
    reset_session
    flash[:success] = "You have been logged out."
    redirect_back_or_default(homepage_path)
  end
end
