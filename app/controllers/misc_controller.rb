class MiscController < ApplicationController
  def index
    if current_bunny
      redirect_to(valentines_path) and return
    end
    render :action => :index
  end
  
  def privacy
  end
  
  def boom
    raise "Boom!"
  end
end
