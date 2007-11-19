require File.dirname(__FILE__) + '/../test_helper'
require 'valentines_controller'

# Re-raise errors caught by the controller.
class ValentinesController; def rescue_action(e) raise e end; end

class ValentinesControllerTest < Test::Unit::TestCase
  fixtures :bunnies, :valentines
  
  def setup
    @controller = ValentinesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_new
    get :new
    assert_response :success
    assert_template "valentines/new"
    assert_new_valentine_form
  end
  
  def test_create
    login_as(:bunny => :chrismear)
    assert_difference Valentine, :count do
      post :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :redirect
    assert_redirected_to "/bunnies/1"
    
    valentine = Valentine.find(:first, :order => "id DESC")
    
    assert_equal bunnies(:chrismear), valentine.sender
    assert_equal bunnies(:bob), valentine.recipient
    assert_equal "Back at ya.", valentine.message
    assert valentine.created_at
  end
  
  def test_create_when_not_logged_in
    assert_no_difference Valentine, :count do
      post :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :redirect
    assert_redirected_to "/"
    assert_nil @response.session[:bunny]
  end
end
