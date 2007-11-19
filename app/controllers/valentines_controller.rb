class ValentinesController < ApplicationController
  def new
  end
  
  def create
    sender = current_bunny
    unless sender
      reset_session
      redirect_to(homepage_path) and return
    end
    
    @recipient = Bunny.find_by_username(params[:recipient]) || Bunny.create(:username => params[:recipient])
    
    @message = params[:message]
    
    valentine = Valentine.create(:sender => sender, :recipient => @recipient, :message => @message)
    
    if valentine
      flash[:success] = "Your Valentine has been sent!"
      redirect_to(bunny_path(sender))
    else
      render(:action => :new)
    end
  end
end
