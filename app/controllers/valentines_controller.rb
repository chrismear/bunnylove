class ValentinesController < ApplicationController
  def new
  end
  
  def create
    if current_bunny
      flash[:error] = "No more Valentines this year, sorry!"
      redirect_to(bunny_path(current_bunny))
    else
      redirect_to(homepage_path)
    end
  end
end
