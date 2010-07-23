# Copyright 2007, 2008, 2009, 2010 Chris Mear
# 
# This file is part of Bunnylove.
# 
# Bunnylove is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Bunnylove is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with Bunnylove.  If not, see <http://www.gnu.org/licenses/>.

require 'test_helper'

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
