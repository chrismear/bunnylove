require File.dirname(__FILE__) + '/../test_helper'
require 'misc_controller'

# Re-raise errors caught by the controller.
class MiscController; def rescue_action(e) raise e end; end

class MiscControllerTest < Test::Unit::TestCase
  fixtures :bunnies
  
  def setup
    @controller = MiscController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index_when_logged_out
    get :index
    assert_response :success
    assert_template "misc/index"
    
    assert_sign_up_form
    assert_login_form
  end
  
  def test_index_when_logged_in
    login_as(:bunny => :chrismear)
    
    get :index
    
    assert_response :redirect
    assert_redirected_to "/bunnies/1"
  end
  
  def test_privacy
    get :privacy
    assert_response :success
    assert_template "misc/privacy"
  end
end
