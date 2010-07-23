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

class ValentinesControllerTest < ActionController::TestCase
  fixtures :bunnies, :valentines
  
  def setup
    Valentine.start_month = 1
    Valentine.start_day = 1
    Valentine.end_day = 31
    Valentine.end_month = 12
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
  
  def test_create_with_ajax
    login_as(:bunny => :chrismear)
    assert_difference "Valentine.count" do
      xhr :post, :create, :recipient => "bob", :message => "Back at ya."
    end
    assert_response :success
    assert_equal 3, assigns(:sent_valentines_count)
    assert_select_rjs :replace_html, "create_valentine_form_success"
    assert_select_rjs :replace_html, "sent_valentines_tally"
    assert_select_rjs :insert, :top, "sent_valentines" do
      assert_select "li", 1
    end
  end
  
  def test_create_with_ajax_with_blank_recipient
    login_as(:bunny => :chrismear)
    assert_no_difference "Valentine.count" do
      xhr :post, :create, :recipient => "", :message => "Back at ya."
    end
    assert_response :success
    assert_select_rjs :replace_html, "create_valentine_form_error"
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
    assert_select "form[action=/valentines][method=post][onsubmit*=new Ajax.Request]" do
      assert_select "input[name=recipient]"
      assert_select "textarea[name=message]"
      assert_select "input[type=submit]"
    end
    
    # Correctly-IDed elements for AJAX responses
    assert_select "p[id=create_valentine_form_error]"
    assert_select "p[id=create_valentine_form_success]"
    assert_select "p[id=sent_valentines_tally]"
    assert_select "p[id=received_valentines_tally]"
    assert_select "ul[id=received_valentines]"
    assert_select "ul[id=sent_valentines]"
    
    # TODO: Code for periodic updater
    
    
    # Logout link
    assert_select "a[href=/bunny_sessions/current][onclick*=delete]"
    
    # Change password link
    assert_select "a[href=/bunnies/current/edit]"
  end
  
  def test_new
    login_as(:bunny => :chrismear)
    get :new
    assert_select "form[action=/valentines][method=post]" do
      assert_select "input[name=recipient]"
      assert_select "textarea[name=message]"
      assert_select "input[type=submit]"
    end
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
  
  def test_received_atom
    # N.B. No login required
    
    get :received, :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"
    assert_response :success
    
    assert_select "feed" do
      assert_select "link[href*=http://test.host]"
      assert_select "title", "My Bunny Love Valentines"
      # Should only get the two valentines from this year
      assert_select "entry", 2
      assert_select "entry" do
        assert_select "title", /Shall I compare thee/
      end
      assert_select "entry" do
        assert_select "title", /Thou art more lovely/
      end
    end
  end
  
  def test_received_atom_with_no_valentines
    bunnies(:chrismear).received_valentines.destroy_all
    
    get :received, :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "atom"
    assert_response :success
  end
  
  def test_received_rss_with_no_valentines
    bunnies(:chrismear).received_valentines.destroy_all
    
    get :received, :bunny_id => "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", :format => "rss"
    assert_response :success
  end
  
  def test_received_atom_with_bad_key
    get :received, :bunny_id => "doesnotexist", :format => "atom"
    assert_response 404
  end
  
  def test_received_rss_with_bad_key
    get :received, :bunny_id => "doesnotexist", :format => "rss"
    assert_response 404
  end
  
  def test_received_after
    login_as(:bunny => :chrismear)
    
    xhr :post, :received_after, :last_id => 13
    
    assert_response :success
    
    assert_equal 2, assigns(:received_valentines_count)
    
    assert_select_rjs :replace_html, "received_valentines_tally"
    assert_select_rjs :insert, :top, "received_valentines" do
      assert_select "li", 1
    end
  end
  
  def test_received_after_with_zero_id_should_not_fetch_previous_years_valentines
    # In a new year, before any valentines have been sent, the code for valentines/index.html.erb
    # sets lastReceivedValentineId to zero. Previously, the received_after action didn't bother checking the year,
    # so it would then go and fetch all of the valentines from ID zero upwards, including previous years'.
    # It shouldn't do this. Instead, it should only fetch valentines from this year.
    login_as(:bunny => :chrismear)
    
    xhr :post, :received_after, :last_id => 0
    
    assert_response :success
    
    assert_select_rjs :insert, :top, "received_valentines" do
      assert_select "li", 2
      assert_select "li[id=received_valentine_13]"
      assert_select "li[id=received_valentine_14]"
    end
  end
end
