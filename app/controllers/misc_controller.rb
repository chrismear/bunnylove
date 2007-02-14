class MiscController < ApplicationController
  def index
    if current_bunny
      redirect_to(bunny_path(current_bunny)) and return
    end
    
    @bunny = Bunny.new
  end
  
  def privacy
  end
end
