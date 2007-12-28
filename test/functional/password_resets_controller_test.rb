require File.dirname(__FILE__) + '/../test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  fixtures :bunnies
  
  def test_new
    get :new
    assert_response :success
    assert_select "form[action=/password_resets/new/secret]" do
      assert_select "input[name=username]"
      assert_select "input[type=submit]"
    end
  end
  
  def test_secret
    old_secret = bunnies(:chrismear).secret
    post :secret, :username => "chrismear"
    assert_response :success
    bunnies(:chrismear).reload
    assert_not_equal old_secret, bunnies(:chrismear).secret
    assert_select "p", Regexp.new(bunnies(:chrismear).secret)
    assert_select "a[href=http://metachat.org/users/chrismear]"
    assert_select "form[action=/password_resets/1/check]" do
      assert_select "input[type=submit]"
    end
  end
  
  def test_secret_with_non_existent_username
    post :secret, :username => "onfg"
    assert_response :success
    assert_template "password_resets/new"
  end
  
  def test_check
    Metachat.secret_check_succeed = true
    
    post :check, :id => 1
    
    assert_equal 1, session[:pre_bunny]
    
    assert_response :success
    assert_select "form[action=/password_resets]" do
      assert_select "input[name=password][type=password]"
      assert_select "input[name=password_confirmation][type=password]"
      assert_select "input[type=submit]"
    end
  end
  
  def test_check_failed
    Metachat.secret_check_succeed = false
    
    post :check, :id => 1
    
    assert_response :success
    assert_template "password_resets/secret"
    
    assert_nil session[:pre_bunny]
  end
  
  def test_create
    @request.session[:pre_bunny] = 1
    post :create, :password => "newpassword", :password_confirmation => "newpassword"
    assert_response :redirect
    assert_redirected_to "/valentines"
    assert_equal 1, session[:bunny]
    assert_equal bunnies(:chrismear), Bunny.authenticate("chrismear", "newpassword")
  end
  
  def test_create_with_empty_parameters
    @request.session[:pre_bunny] = 1
    post :create, :password => "", :password_confirmation => ""
    assert_response :success
    assert_template "password_resets/check"
    assert_equal bunnies(:chrismear), Bunny.authenticate("chrismear", "qwerty")
  end
  
  def test_create_with_incorrect_confirmation
    @request.session[:pre_bunny] = 1
    post :create, :password => "newpassword", :password_confirmation => "incorrect confirmation"
    assert_response :success
    assert_template "password_resets/check"
    assert_equal bunnies(:chrismear), Bunny.authenticate("chrismear", "qwerty")
  end
end
