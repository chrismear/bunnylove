require File.dirname(__FILE__) + '/../test_helper'
require 'misc_controller'

# Re-raise errors caught by the controller.
class MiscController; def rescue_action(e) raise e end; end

class MiscControllerTest < Test::Unit::TestCase
  def setup
    @controller = MiscController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
