require "#{File.dirname(__FILE__)}/../test_helper"

class RoutingTest < ActionController::IntegrationTest
  # fixtures :your, :models
  
  def test_received_valentines_rss
    assert_routing "/bunnies/0bd994c5927d45ca9ffd8be84a8e45973e4073b6/valentines/received.rss", :controller => "valentines", :action => "received", :format => "rss", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"
    
    assert_routing received_bunny_valentines_path(:bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"), :controller => "valentines", :action => "received", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"
  end
  
  def test_received_valentines_atom
    assert_routing "/bunnies/0bd994c5927d45ca9ffd8be84a8e45973e4073b6/valentines/received.atom", :controller => "valentines", :action => "received", :format => "atom", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"
    
    assert_routing received_bunny_valentines_path(:bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"), :controller => "valentines", :action => "received", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"
  end
  
  def test_normal_valentines_routes
    assert_routing "/valentines", :controller => "valentines", :action => "index"
    assert_routing "/valentines/received_after", :controller => "valentines", :action => "received_after"
  end
  
  def test_received_frights_rss
    assert_routing "/bunnies/0bd994c5927d45ca9ffd8be84a8e45973e4073b6/frights/received.rss", :controller => "frights", :action => "received", :format => "rss", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"
    
    assert_routing received_bunny_frights_path(:bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"), :controller => "frights", :action => "received", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"
  end
  
  def test_received_frights_atom
    assert_routing "/bunnies/0bd994c5927d45ca9ffd8be84a8e45973e4073b6/frights/received.atom", :controller => "frights", :action => "received", :format => "atom", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6"
    
    assert_routing received_bunny_frights_path(:bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"), :controller => "frights", :action => "received", :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"
  end
  
  def test_normal_frights_routes
    assert_routing "/frights", :controller => "frights", :action => "index"
    assert_routing "/frights/received_after", :controller => "frights", :action => "received_after"
  end
end
