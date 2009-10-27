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
