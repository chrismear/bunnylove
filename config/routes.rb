ActionController::Routing::Routes.draw do |map|
  map.resources "bunnies",
                :new => {:secret => :post},
                :member => {:check => :post}
  map.resources "bunny_sessions"
  map.resources "valentines",
                :collection => {:received => :get, :received_after => :post}
  
  map.homepage "/", :controller => "misc", :action => "index"
  map.privacy "/privacy", :controller => "misc", :action => "privacy"
end
