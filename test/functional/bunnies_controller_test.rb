require File.dirname(__FILE__) + '/../test_helper'
require 'bunnies_controller'

# Re-raise errors caught by the controller.
class BunniesController; def rescue_action(e) raise e end; end

class BunniesControllerTest < Test::Unit::TestCase
  def setup
    @controller = BunniesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
