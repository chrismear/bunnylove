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
