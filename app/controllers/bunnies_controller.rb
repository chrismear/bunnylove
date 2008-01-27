class BunniesController < ApplicationController
  before_filter :bunny_login_required, :only => [:edit, :update]
  layout "logged_in", :only => [:edit, :update]
  
  def new
  end
  
  def secret
    @bunny = Bunny.update_by_username_or_new(params[:bunny])
    
    if @bunny.signed_up?
      flash[:error] = "Whoops! Looks like you've already signed up. Perhaps you wanted to log in instead?"
      redirect_to(new_bunny_session_path) and return
    end
    
    # If the bunny already has a password, then the password the user has just entered must match
    raise BadBunny if @bunny.crypted_password && (@bunny != Bunny.authenticate(@bunny.username, params[:bunny][:password]))
    
    raise BadBunny unless @bunny.save
    
    session[:pre_bunny] = @bunny.id
    @bunny.generate_secret! unless @bunny.secret
    
  rescue BadBunny
    flash[:error] = "Uh-oh. Something wasn't right there."
    render(:action => :new)
  end
  
  def check
    @bunny = Bunny.find(params[:id])
    if session[:pre_bunny] != @bunny.id
      redirect_to(homepage_path) and return
    end
    
    if @bunny.check_secret!
      self.current_bunny = @bunny
      flash[:success] = "Okay, you're all set. Have fun!"
      redirect_to(valentines_path)
    else
      flash[:error] = "Uh-oh. I couldn't find your code on your MeCha profile page. Are you sure you put it there?"
      render(:action => :secret)
    end
  end
  
  def edit
    @bunny = self.current_bunny
  end
  
  def update
    @bunny = self.current_bunny
    @bunny.crypted_password = nil
    @bunny.password = params[:bunny][:password]
    @bunny.password_confirmation = params[:bunny][:password_confirmation]
    if @bunny.save
      flash[:success] = "Your password has been changed!"
      redirect_to valentines_path
    else
      flash[:error] = "Uh-oh, something was wrong there."
      render :action => :edit
    end
  end
  
  private
  
  class BadBunny < RuntimeError; end
end
