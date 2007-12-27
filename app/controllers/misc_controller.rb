class MiscController < ApplicationController
  def index
    if current_bunny
      redirect_to(valentines_path) and return
    end
    
    @bunny = Bunny.new
  end
  
  def privacy
  end
end
