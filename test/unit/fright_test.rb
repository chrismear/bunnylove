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

class FrightTest < ActiveSupport::TestCase
  fixtures :frights, :bunnies
  
  def test_should_have_sender
    assert_equal bunnies(:chrismear), frights(:to_confirmed_bunny).sender
  end
  
  def test_should_have_recipient
    assert_equal bunnies(:confirmed_bunny), frights(:to_confirmed_bunny).recipient
  end
  
  def test_should_be_able_to_create_fright
    assert_difference "Fright.count" do
      fright = create_fright
      assert !fright.new_record?
    end
  end
  
  def test_should_require_message
    assert_no_difference "Fright.count" do
      fright = create_fright(:message => "")
      assert fright.errors.on(:message)
    end
  end
  
  def test_should_require_sender
    assert_no_difference "Fright.count" do
      fright = create_fright(:sender => nil)
      assert fright.errors.on(:sender)
    end
  end
  
  def test_should_require_recipient
    assert_no_difference "Fright.count" do
      fright = create_fright(:recipient => nil)
      assert fright.errors.on(:recipient)
    end
  end
  
  def test_should_set_created_at_on_create
    fright = create_fright
    assert fright.created_at
  end
  
  def test_rot13
    assert_equal "Ebfrf ner erq", Fright.rot13("Roses are red")
    assert_equal "Chapghngvba, pvgl!", Fright.rot13("Punctuation, city!")
  end
  
  def test_saving_fright_rot13s_message
    fright = create_fright
    assert_equal "V fp-fp-fpner lbh!", fright.message
  end
  
  def test_instantiating_fright_with_empty_message
    # Make sure we don't try and call nil.tr
    assert_nothing_raised do
      fright = Fright.new(:message => nil)
    end
  end
  
  def test_allow_frights
    Fright.start_month = 10
    Fright.start_day = 31
    Fright.end_month = 11
    Fright.end_day = 1
    
    assert !Fright.allow_frights?(Time.utc(2008, 10, 30, 23, 54))
    assert Fright.allow_frights?(Time.utc(2008, 10, 31, 0, 23))
    assert Fright.allow_frights?(Time.utc(2008, 11, 1, 23, 33))
    assert !Fright.allow_frights?(Time.utc(2008, 11, 2, 0, 2))
  end
  
  def test_before_and_after_halloween
    Fright.start_month = 10
    Fright.start_day = 31
    Fright.end_month = 11
    Fright.end_day = 1
    
    assert Fright.before_halloween?(Time.utc(2008,10,30,23,54))
    assert !Fright.after_halloween?(Time.utc(2008,10,30,23,54))
    
    assert Fright.after_halloween?(Time.utc(2008,11,2,0,2))
    assert !Fright.before_halloween?(Time.utc(2008,11,2,0,2))
  end
  
  private
  
  def create_fright(options={})
    Fright.create({:message => "I sc-sc-scare you!", :sender => bunnies(:chrismear), :recipient => bunnies(:confirmed_bunny)}.merge(options))
  end
end
