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

class BunnySessionsControllerTest < ActionController::TestCase
  fixtures :bunnies
    
  def test_should_login_and_redirect
    post :create, :username => 'chrismear', :password => 'qwerty'
    assert_equal 1, session[:bunny]
    assert_response :redirect
    assert_redirected_to "/valentines"
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
