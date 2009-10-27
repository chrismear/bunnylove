require 'test_helper'

class MiscControllerTest < ActionController::TestCase
  fixtures :bunnies
    
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
    assert_redirected_to "/valentines"
  end
  
  def test_privacy
    get :privacy
    assert_response :success
    assert_template "misc/privacy"
  end
end
