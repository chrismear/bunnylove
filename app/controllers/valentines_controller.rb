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

class ValentinesController < ApplicationController
  layout "valentines", :except => :received
  before_filter :bunny_login_required, :except => :received
  before_filter :find_bunny
  before_filter :get_current_year, :only => [:index, :received, :received_after, :create]
  
  def index
    @received_valentines = @bunny.received_valentines_for_year(@year)
    @sent_valentines = @bunny.sent_valentines_for_year(@year)
    @allow_valentines = Valentine.allow_valentines?
    @before_valentines = Valentine.before_valentines?
    @after_valentines = Valentine.after_valentines?
  end
  
  def new
  end
  
  def create
    @recipient = Bunny.find_by_username(params[:recipient]) || Bunny.create_proto_bunny(params[:recipient])
    
    @message = params[:message]
    
    @valentine = Valentine.new(:sender => current_bunny, :recipient => @recipient, :message => @message)
    
    if @valentine.save
      flash[:success] = "Your Valentine has been sent to #{@recipient.username}!"
      @sent_valentines_count = @bunny.count_sent_valentines_for_year(@year)
      respond_to do |format|
        format.html do
          redirect_to(valentines_path)
        end
        format.js
      end
    else
      flash[:error] = "Sorry, something's missing there."
      respond_to do |format|
        format.html do
          render(:action => :new)
        end
        format.js do
          render(:action => :error)
        end
      end
    end
  end
  
  def show
    @year = params[:id]
    @received_valentines = @bunny.received_valentines_for_year(@year)
    @sent_valentines = @bunny.sent_valentines_for_year(@year)
  end
  
  def received
    unless @bunny
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
    @received_valentines = @bunny.received_valentines_for_year(@year)
    respond_to do |format|
      format.rss
      format.atom
    end
  end
  
  def received_after
    @new_valentines = @bunny.received_valentines_after(params[:last_id], @year)
    @received_valentines_count = @bunny.count_received_valentines_for_year(@year)
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def find_bunny
    @bunny = current_bunny || Bunny.find_by_key(params[:bunny_id])
  end
  
  def get_current_year
    @year = Time.now.utc.year
  end
end
