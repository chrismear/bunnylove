require File.dirname(__FILE__) + '/../test_helper'
require 'bunnies_controller'

# Re-raise errors caught by the controller.
class BunniesController; def rescue_action(e) raise e end; end

class BunniesControllerTest < Test::Unit::TestCase
  fixtures :bunnies, :valentines
  
  def setup
    @controller = BunniesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_new
    get :new
    assert_response :success
    assert_sign_up_form
  end
  
  def test_secret
    assert_difference "Bunny.count" do
      post :secret, :bunny => {:username => "taz", :password => "letmein", :password_confirmation => "letmein"}
    end
    
    bunny = Bunny.find(:first, :order => "id DESC")
    
    assert_equal "taz", bunny.username
    
    assert bunny.secret
    
    assert_select "p", Regexp.new(bunny.secret)
    
    assert_select "a[href=http://metachat.org/users/taz]"
    
    assert_select "form[action=/bunnies/#{bunny.id}/check][method=post]" do
      assert_select "input[type=submit]"
    end
  end
  
  def test_secret_with_already_confirmed_bunny
    # Password entered doesn't matter, since we're just going to redirect them to a login page.
    assert_no_difference "Bunny.count" do
      post :secret, :bunny => {:username => "chrismear", :password => "whatever", :password_confirmation => "doesn't matter"}
    end
    
    assert flash[:error]
    
    assert_redirected_to("/bunny_sessions/new")
  end
  
  def test_secret_with_unconfirmed_bunny_which_already_has_password_and_correct_password_has_been_entered
    # Must enter the correct password to be shown the 'check' screen, otherwise someone else could enter the name of an unconfirmed bunny, get to the 'secret' page, and if the actual bunny has already added the secret to their MetaChat user page, then the imposter could just click the "let me in" button and be logged in automatically.
    # But if someone does abandon the sign-up process halfway through, they should be able to come back and resume it.
    # In the future, perhaps we should allow someone to enter a username that already has an unconfirmed bunny record in the DB, choose a new password, which then forces a new secret to be generated. This would make resuming abandoned sign-ups easier (since they're not required to remember the password they chose last time), while still stopping imposters from hijacking unconfirmed accounts.
    assert_no_difference "Bunny.count" do
      post :secret, :bunny => {:username => "unconfirmed", :password => "qwerty", :password_confirmation => "qwerty"}
    end
    
    bunny = bunnies(:unconfirmed_bunny)
    
    # Shouldn't generate a new secret
    assert_equal "abcdef", bunny.secret
    
    assert_response :success
    
    assert_select "p", /abcdef/
    
    assert_select "a[href=http://metachat.org/users/unconfirmed]"
    
    assert_select "form[action=/bunnies/2/check][method=post]" do
      assert_select "input[type=submit]"
    end
  end
  
  def test_secret_with_unconfirmed_bunny_which_already_has_password_and_bad_password_has_been_entered
    # Should throw up an error if bad password is given.
    assert_no_difference "Bunny.count" do
      post :secret, :bunny => {:username => "unconfirmed", :password => "wrong_password", :password_confirmation => "wrong_password"}
    end
    
    assert flash[:error]
    assert_response :success
    assert_template "bunnies/new"
  end
  
  def test_secret_with_automatically_created_bunny
    assert_no_difference "Bunny.count" do
      post :secret, :bunny => {:username => "automatic", :password => "letmein", :password_confirmation => "letmein"}
    end
    
    bunny = Bunny.find_by_username("automatic")
    
    assert bunny.secret
    
    assert_select "p", Regexp.new(bunny.secret)
    
    assert_select "a[href=http://metachat.org/users/automatic]"
    
    assert_select "form[action=/bunnies/4/check][method=post]" do
      assert_select "input[type=submit]"
    end
    
    
  end
  
  def test_secret_with_new_bunny_and_errors
    assert_no_difference "Bunny.count" do
      post :secret, :bunny => {:username => "new_bunny", :password => "password", :password_confirmation => "incorrect password confirmation"}
    end
    
    assert flash[:error]
    assert_response :success
    assert_template "bunnies/new"
  end
  
  def test_check
    Metachat.secret_check_succeed = true
    
    @request.session[:pre_bunny] = 2
    get :check, :id => 2
    assert_response :redirect
    assert_redirected_to "/bunnies/2"
    
    assert_equal 2, @response.session[:bunny]
    assert bunnies(:unconfirmed_bunny).signed_up?
  end
  
  def test_check_fail
    Metachat.secret_check_succeed = false
    
    @request.session[:pre_bunny] = 2
    get :check, :id => 2
    assert_response :success
    assert_template "bunnies/secret"
    assert flash[:error]
  end
  
  def test_spoofed_check_request
    Metachat.secret_check_succeed = true
    
    @request.session[:pre_bunny] = nil
    get :check, :id => 2
    assert_response :redirect
    assert_redirected_to "/"
    assert_nil @response.session[:pre_bunny]
  end
  
  def test_show
    login_as(:bunny => :chrismear)
    
    get :show, :id => "current"
    
    assert_response :success
    assert_template "bunnies/show"
    
    # Received valentines count
    assert_select "p", /received 2 valentines/
    
    # Received valentines
    assert_select "li", /compare thee/
    assert_select "li", /more lovely/
    
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
  
  def test_show_when_not_logged_in
    get :show, :id => "current"
    
    assert_response :redirect
    assert_redirected_to "/bunny_sessions/new"
  end
end
