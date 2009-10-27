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
