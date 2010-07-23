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

class ValentineTest < ActiveSupport::TestCase
  fixtures :valentines, :bunnies
  
  def test_should_have_sender
    assert_equal bunnies(:chrismear), valentines(:to_confirmed_bunny).sender
  end
  
  def test_should_have_recipient
    assert_equal bunnies(:confirmed_bunny), valentines(:to_confirmed_bunny).recipient
  end
  
  def test_should_be_able_to_create_valentine
    assert_difference "Valentine.count" do
      valentine = create_valentine
      assert !valentine.new_record?
    end
  end
  
  def test_should_require_message
    assert_no_difference "Valentine.count" do
      valentine = create_valentine(:message => "")
      assert valentine.errors.on(:message)
    end
  end
  
  def test_should_require_sender
    assert_no_difference "Valentine.count" do
      valentine = create_valentine(:sender => nil)
      assert valentine.errors.on(:sender)
    end
  end
  
  def test_should_require_recipient
    assert_no_difference "Valentine.count" do
      valentine = create_valentine(:recipient => nil)
      assert valentine.errors.on(:recipient)
    end
  end
  
  def test_should_set_created_at_on_create
    valentine = create_valentine
    assert valentine.created_at
  end
  
  def test_rot13
    assert_equal "Ebfrf ner erq", Valentine.rot13("Roses are red")
    assert_equal "Chapghngvba, pvgl!", Valentine.rot13("Punctuation, city!")
  end
  
  def test_saving_valentine_rot13s_message
    valentine = create_valentine
    assert_equal "V pubb-pubb-pubbfr lbh!", valentine.message
  end
  
  def test_instantiating_valentine_with_empty_message
    # Make sure we don't try and call nil.tr
    assert_nothing_raised do
      valentine = Valentine.new(:message => nil)
    end
  end
  
  def test_allow_valentines
    Valentine.start_month = 2
    Valentine.start_day = 14
    Valentine.end_month = 2
    Valentine.end_day = 15
    
    assert !Valentine.allow_valentines?(Time.utc(2008, 2, 13, 23, 54))
    assert Valentine.allow_valentines?(Time.utc(2008, 2, 14, 0, 23))
    assert Valentine.allow_valentines?(Time.utc(2008, 2, 15, 23, 33))
    assert !Valentine.allow_valentines?(Time.utc(2008, 2, 16, 0, 2))
  end
  
  def test_before_and_after_valentines
    Valentine.start_month = 2
    Valentine.start_day = 14
    Valentine.end_month = 2
    Valentine.end_day = 15
    
    assert Valentine.before_valentines?(Time.utc(2008,2,13,23,54))
    assert !Valentine.after_valentines?(Time.utc(2008,2,13,23,54))
    
    assert Valentine.after_valentines?(Time.utc(2008,2,16,0,2))
    assert !Valentine.before_valentines?(Time.utc(2008,2,16,0,2))
  end
  
  private
  
  def create_valentine(options={})
    Valentine.create({:message => "I choo-choo-choose you!", :sender => bunnies(:chrismear), :recipient => bunnies(:confirmed_bunny)}.merge(options))
  end
end
