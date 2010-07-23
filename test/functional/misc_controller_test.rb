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
