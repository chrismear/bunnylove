require "#{File.dirname(__FILE__)}/../test_helper"

class RoutingTest < ActionController::IntegrationTest
  # fixtures :your, :models
  
  def test_received_rss
    assert_routing "/bunnies/0bd994c5927d45ca9ffd8be84a8e45973e4073b6/valentines/received.rss", :controller => "valentines", :action => "received", :format => "rss", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"
    
    assert_routing received_bunny_valentines_path(:bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"), :controller => "valentines", :action => "received", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"
  end
  
  def test_normal_valentines_routes
    assert_routing "/valentines", :controller => "valentines", :action => "index"
    assert_routing "/valentines/received_after", :controller => "valentines", :action => "received_after"
  end
end
