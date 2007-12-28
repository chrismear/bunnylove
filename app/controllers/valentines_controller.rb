class ValentinesController < ApplicationController
  before_filter :bunny_login_required, :except => :received
  layout "logged_in", :except => :received
  before_filter :find_bunny
  before_filter :get_current_year, :only => [:index, :received]
  
  def index
    @received_valentines = @bunny.received_valentines_for_year(@year)
    @sent_valentines = @bunny.sent_valentines_for_year(@year)
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
      @sent_valentines_count = @bunny.sent_valentines.count
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
  
  def show
    @year = params[:id]
    @received_valentines = @bunny.received_valentines_for_year(@year)
    @sent_valentines = @bunny.sent_valentines_for_year(@year)
  end
  
  def received
    @received_valentines = @bunny.received_valentines_for_year(@year)
    respond_to do |format|
      format.rss
    end
  end
  
  def received_after
    @new_valentines = @bunny.received_valentines_after(params[:last_id])
    @received_valentines_count = @bunny.received_valentines.count
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def find_bunny
    @bunny = current_bunny || Bunny.find_by_key(params[:bunny_id])
  end
  
  def get_current_year
    @year = Time.now.utc.year
  end
end
