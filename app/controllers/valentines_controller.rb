class ValentinesController < ApplicationController
  before_filter :bunny_login_required
  
  def new
  end
  
  def create
    sender = current_bunny
    unless sender
      reset_session
      respond_to do |format|
        format.html {redirect_to(homepage_path)}
        format.js do
          flash[:error] = "Uh-oh, something went wrong there. Please log out and try again."
          render(:action => :error)
        end
      end
      return
    end
    
    @recipient = Bunny.find_by_username(params[:recipient]) || Bunny.create(:username => params[:recipient])
    
    @message = params[:message]
    
    @valentine = Valentine.new(:sender => sender, :recipient => @recipient, :message => @message)
    
    if @valentine.save
      respond_to do |format|
        format.html do
          flash[:success] = "Your Valentine has been sent!"
          redirect_to(bunny_path("current"))
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = "Sorry, something's missing there."
          render(:action => :new)
        end
        format.js do
          flash[:error] = "Sorry, something's missing there."
          render(:action => :error)
        end
      end
    end
  end
  
  def received
    @bunny = current_bunny
    @received_valentines = @bunny.received_valentines
    respond_to do |format|
      format.html
      format.rss
    end
  end
end
