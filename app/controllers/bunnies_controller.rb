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

class BunniesController < ApplicationController
  before_filter :bunny_login_required, :only => [:edit, :update]
  
  def new
  end
  
  def secret
    @bunny = Bunny.update_by_username_or_new(params[:bunny])
    
    if @bunny.signed_up?
      flash[:error] = "Whoops! Looks like you've already signed up. Perhaps you wanted to log in instead?"
      redirect_to(new_bunny_session_path) and return
    end
    
    # If the bunny already has a password, then the password the user has just entered must match
    raise BadBunny if @bunny.crypted_password && (@bunny != Bunny.authenticate(@bunny.username, params[:bunny][:password]))
    
    raise BadBunny unless @bunny.save
    
    session[:pre_bunny] = @bunny.id
    @bunny.generate_secret! unless @bunny.secret
    
  rescue BadBunny
    flash[:error] = "Uh-oh. Something wasn't right there."
    render(:action => :new)
  end
  
  def check
    @bunny = Bunny.find(params[:id])
    if session[:pre_bunny] != @bunny.id
      redirect_to(homepage_path) and return
    end
    
    if @bunny.check_secret!
      self.current_bunny = @bunny
      flash[:success] = "Okay, you're all set. Have fun!"
      if Fright.allow_frights?
        redirect_to(frights_path)
      else
        redirect_to(valentines_path)
      end
    else
      flash[:error] = "Uh-oh. I couldn't find your code on your MeCha profile page. Are you sure you put it there?"
      render(:action => :secret)
    end
  end
  
  def edit
    @bunny = self.current_bunny
    if Fright.allow_frights?
      render(:layout => 'frights')
    else
      render(:layout => 'valentines')
    end
  end
  
  def update
    @bunny = self.current_bunny
    @bunny.crypted_password = nil
    @bunny.password = params[:bunny][:password]
    @bunny.password_confirmation = params[:bunny][:password_confirmation]
    if @bunny.save
      flash[:success] = "Your password has been changed!"
      if Fright.allow_frights?
        redirect_to frights_path
      else
        redirect_to valentines_path
      end
    else
      flash[:error] = "Uh-oh, something was wrong there."
      if Fright.allow_frights?
        render :action => :edit, :layout => 'frights'
      else
        render :action => :edit, :layout => 'valentines'
      end
    end
  end
  
  private
  
  class BadBunny < RuntimeError; end
end
