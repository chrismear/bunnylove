require "#{File.dirname(__FILE__)}/../test_helper"

class RoutingTest < ActionController::IntegrationTest
  # fixtures :your, :models
  
  def test_received_rss
    assert_routing "/valentines/received.rss", :controller => "valentines", :action => "received", :format => "rss"
  end
end
