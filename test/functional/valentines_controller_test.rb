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
    login_as(:bunny => :chrismear)
    get :new
    assert_response :success
    assert_template "valentines/new"
    assert_new_valentine_form
  end
  
  def test_create
    login_as(:bunny => :chrismear)
    assert_difference "Valentine.count" do
      post :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :redirect
    assert_redirected_to "/bunnies/current"
    
    valentine = Valentine.find(:first, :order => "id DESC")
    
    assert_equal bunnies(:chrismear), valentine.sender
    assert_equal bunnies(:bob), valentine.recipient
    assert_equal "Onpx ng ln.", valentine.message
    assert valentine.created_at
  end
  
  def test_create_to_new_bunny
    login_as(:bunny => :chrismear)
    assert_difference "Valentine.count" do
      assert_difference "Bunny.count" do
        post :create, :recipient => "newbunny", :message => "I simply adore you."
      end
    end
    assert_response :redirect
    assert_redirected_to "/bunnies/current"
    
    valentine = Valentine.find(:first, :order => "id DESC")
    bunny = Bunny.find_by_username("newbunny")
    
    assert bunny
    
    assert_equal bunnies(:chrismear), valentine.sender
    assert_equal bunny, valentine.recipient
  end
  
  def test_create_when_not_logged_in
    assert_no_difference "Valentine.count" do
      post :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :redirect
    assert_redirected_to "/bunny_sessions/new"
    assert_nil @response.session[:bunny]
  end
end
