ActionController::Routing::Routes.draw do |map|
  map.resources "bunnies",
                :new => {:secret => :post},
                :member => {:check => :post}
  map.resources "bunny_sessions"
  map.resources "valentines",
                :collection => {:received_after => :any}
  map.resources "password_resets",
                :new => {:secret => :post},
                :member => {:check => :post}
  
  map.homepage "/", :controller => "misc", :action => "index"
  map.privacy "/privacy", :controller => "misc", :action => "privacy"
  
  map.received_bunny_valentines "/bunnies/:bunny_id/valentines/received.rss", :controller => "valentines", :action => "received", :format => "rss"
end
