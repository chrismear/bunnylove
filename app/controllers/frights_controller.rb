class FrightsController < ApplicationController
  layout "frights", :except => :received
  before_filter :bunny_login_required, :except => :received
  before_filter :find_bunny
  before_filter :get_current_year, :only => [:index, :received, :received_after, :create]
  
  def index
    @received_frights = @bunny.received_frights_for_year(@year)
    @sent_frights = @bunny.sent_frights_for_year(@year)
    @allow_frights = Fright.allow_frights?
    @before_halloween = Fright.before_halloween?
    @after_halloween = Fright.after_halloween?
  end
  
  def new
  end
  
  def create
    @recipient = Bunny.find_by_username(params[:recipient]) || Bunny.create_proto_bunny(params[:recipient])
    
    @message = params[:message]
    
    @fright = Fright.new(:sender => current_bunny, :recipient => @recipient, :message => @message)
    
    if @fright.save
      flash[:success] = "Your fright has been sent to #{@recipient.username}!"
      @sent_frights_count = @bunny.count_sent_frights_for_year(@year)
      respond_to do |format|
        format.html do
          redirect_to(frights_path)
        end
        format.js
      end
    else
      flash[:error] = "Sorry, something's missing there."
      respond_to do |format|
        format.html do
          render(:action => :new)
        end
        format.js do
          render(:action => :error)
        end
      end
    end
  end
  
  def show
    @year = params[:id]
    @received_frights = @bunny.received_frights_for_year(@year)
    @sent_frights = @bunny.sent_frights_for_year(@year)
  end
  
  def received
    unless @bunny
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
    @received_frights = @bunny.received_frights_for_year(@year)
    respond_to do |format|
      format.rss
      format.atom
    end
  end
  
  def received_after
    @new_frights = @bunny.received_frights_after(params[:last_id], @year)
    @received_frights_count = @bunny.count_received_frights_for_year(@year)
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
