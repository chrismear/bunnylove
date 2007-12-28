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
    
    Valentine.start_month = 1
    Valentine.start_day = 1
    Valentine.end_day = 31
    Valentine.end_month = 12
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
    assert_redirected_to "/valentines"
    
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
    assert_redirected_to "/valentines"
    
    valentine = Valentine.find(:first, :order => "id DESC")
    bunny = Bunny.find_by_username("newbunny")
    
    assert bunny
    
    assert_equal bunnies(:chrismear), valentine.sender
    assert_equal bunny, valentine.recipient
  end
  
  def test_should_not_be_able_to_create_with_blank_recipient
    login_as(:bunny => :chrismear)
    assert_no_difference "Valentine.count" do
      post :create, :recipient => "", :message => "I am full of love, love, love for tasty you."
    end
    
    assert flash[:error]
    assert_response :success
    assert_template "valentines/new"
  end
  
  def test_create_when_not_logged_in
    assert_no_difference "Valentine.count" do
      post :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :redirect
    assert_redirected_to "/bunny_sessions/new"
    assert_nil @response.session[:bunny]
  end
  
  def test_index
    login_as(:bunny => :chrismear)
    
    get :index
    
    assert_response :success
    assert_template "valentines/index"
    
    # Received valentines count
    assert_select "p", /2 valentines/
    
    # Received valentines
    assert_select "li", /compare thee/
    assert_match /more temperate\.<br \/>And so on\./, @response.body
    # Sent valentines count
    assert_select "p", /sent 2 valentines/
    
    # Sent valentines
    assert_select "li", /cute and confirmed/
    assert_select "li", /don't exist yet/
    
    # New valentine form
    assert_new_valentine_form
    
    # Logout link
    assert_select "a[href=/bunny_sessions/current][onclick*=delete]"
  end
  
  def test_index_when_not_logged_in
    get :index
    
    assert_response :redirect
    assert_redirected_to "/bunny_sessions/new"
  end
  
  def test_show
    login_as(:bunny => :chrismear)
    
    get :show, :id => 2006
    assert_response :success
    
    # Received
    assert_select "p[id=received_valentines_tally]", /2 valentines/
    assert_select "li[id=received_valentine_1]", /I think you are cute/
    assert_select "li[id=received_valentine_2]", /You are beautiful/
    
    # Sent
    assert_select "p[id=sent_valentines_tally]", /1 valentine/
    assert_select "li[id=sent_valentine_1]", /I think you are cute/
  end
  
  def test_received_rss
    # N.B. No login required
    
    get :received, :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"
    assert_response :success
    
    assert_select "rss" do
      assert_select "channel" do
        assert_select "title"
        assert_select "link"
        # Should only get the two valentines from this year
        assert_select "item", 2
        assert_select "item" do
          assert_select "description", /Shall I compare thee/
        end
        assert_select "item" do
          assert_select "description", /Thou art more lovely/
        end
      end
    end
  end
end
