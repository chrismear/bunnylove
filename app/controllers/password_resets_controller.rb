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

class PasswordResetsController < ApplicationController
  def new
  end
  
  def secret
    @bunny = Bunny.find_by_username(params[:username])
    if @bunny
      @bunny.generate_secret!
    else
      flash[:error] = "Sorry, couldn't find that username."
      render(:action => :new)
    end
  end
  
  def check
    @bunny = Bunny.find_by_id(params[:id])
    if @bunny.check_secret!
      session[:pre_bunny] = @bunny.id
    else
      flash[:error] = "Uh-oh. I couldn't find your code on your MeCha profile page. Are you sure you put it there?"
      render(:action => :secret)
    end
  end
  
  def create
    @bunny = Bunny.find(session[:pre_bunny])
    @bunny.crypted_password = nil
    @bunny.password = params[:password]
    @bunny.password_confirmation = params[:password_confirmation]
    if @bunny.save
      self.current_bunny = @bunny
      if Fright.allow_frights?
        flash[:success] = "Your password has been changed. Welcome back! Mwah-hah-hah."
        redirect_to(frights_path)
      else
        flash[:success] = "Your password has been changed. Welcome back to Bunny Love!"
        redirect_to(valentines_path)
      end
    else
      flash[:error] = "There was a problem with the new password."
      render(:action => :check)
    end
  end
end
