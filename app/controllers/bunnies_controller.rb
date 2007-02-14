class BunniesController < ApplicationController
  def new
    @bunny = Bunny.new
  end
  
  def secret
    @bunny = Bunny.find_by_username(params[:bunny][:username])
    if @bunny && @bunny.signed_up?
      flash[:error] = "Whoops! Looks like you've already signed up. Perhaps you wanted to log in instead?"
      redirect_to(new_bunny_session_path) and return
    end
    
    @bunny ||= Bunny.new(:username => params[:bunny][:username])
    
    @bunny.password = params[:bunny][:password]
    @bunny.password_confirmation = params[:bunny][:password_confirmation]
    
    if @bunny.save
      session[:pre_bunny] = @bunny.id
      @bunny.generate_secret!
    else
      flash[:error] = "Uh-oh. Something wasn't right there."
      render(:action => :new)
    end
  end
  
  def check
    @bunny = Bunny.find(params[:id])
    if session[:pre_bunny] != @bunny.id
      redirect_to(homepage_path) and return
    end
    
    if @bunny.check_secret!
      self.current_bunny = @bunny
      flash[:success] = "Okay, you're all set. Have fun!"
      redirect_to(bunny_path(@bunny))
    else
      flash[:error] = "Uh-oh. I couldn't find your code on your MeCha profile page. Are you sure you put it there?"
      render(:action => :secret)
    end
  end
  
  def show
    @bunny = Bunny.find(params[:id])
    if @bunny != current_bunny
      reset_session
      redirect_to(homepage_path)
    end
    
    @received_valentines = @bunny.received_valentines
    @sent_valentines = @bunny.sent_valentines
  end
end
