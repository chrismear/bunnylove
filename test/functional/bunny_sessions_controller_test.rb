require File.dirname(__FILE__) + '/../test_helper'
require 'bunny_sessions_controller'

# Re-raise errors caught by the controller.
class BunnySessionsController; def rescue_action(e) raise e end; end

class BunnySessionsControllerTest < Test::Unit::TestCase
  fixtures :bunnies
  
  def setup
    @controller = BunnySessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_login_and_redirect
    post :create, :username => 'chrismear', :password => 'qwerty'
    assert_equal 1, session[:bunny]
    assert_response :redirect
    assert_redirected_to "/bunnies/current"
  end

  def test_should_fail_login_and_not_redirect
    post :create, :username => 'chrismear', :password => 'bad password'
    assert_nil session[:bunny]
    assert_response :success
    assert_template 'bunny_sessions/new'
  end


  def test_should_logout
    login_as :bunny => :chrismear
    delete :destroy, :id => "current"
    assert_nil session[:bunny]
    assert_response :redirect
    assert_redirected_to "/"
  end
end
