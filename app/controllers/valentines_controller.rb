class ValentinesController < ApplicationController
  before_filter :bunny_login_required
  layout "logged_in"
  before_filter :find_bunny
  
  def index
    @received_valentines = @bunny.received_valentines
    @sent_valentines = @bunny.sent_valentines
  end
  
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
    
    @recipient = Bunny.find_by_username(params[:recipient]) || Bunny.create_proto_bunny(params[:recipient])
    
    @message = params[:message]
    
    @valentine = Valentine.new(:sender => sender, :recipient => @recipient, :message => @message)
    
    if @valentine.save
      flash[:success] = "Your Valentine has been sent to #{@recipient.username}!"
      respond_to do |format|
        format.html do
          redirect_to(valentines_path)
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
    @received_valentines = @bunny.received_valentines
    respond_to do |format|
      format.html
      format.rss
    end
  end
  
  private
  
  def find_bunny
    @bunny = current_bunny
  end
end
