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

class MetachatTest < ActiveSupport::TestCase
  def test_user_page_path
    assert_equal "http://metachat.org/users/chrismear", Metachat.user_page_uri("chrismear").to_s
    assert_equal "http://metachat.org/users/It%27s+Raining+Florence+Henderson", Metachat.user_page_uri("It's Raining Florence Henderson").to_s
  end
  
  def test_check_secret_mock
    Metachat.secret_check_succeed = true
    assert Metachat.check_secret("whatever", "doesn't matter")
    
    Metachat.secret_check_succeed = false
    assert !Metachat.check_secret("whatever", "doesn't matter")
  end
end