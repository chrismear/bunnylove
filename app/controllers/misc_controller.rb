class MiscController < ApplicationController
  def index
    if current_bunny
      redirect_to(frights_path) and return
    end
    render :action => :index, :layout => 'index'
  end
  
  def privacy
  end
  
  def boom
    raise "Boom!"
  end
end
