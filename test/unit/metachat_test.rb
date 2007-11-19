require File.dirname(__FILE__) + '/../test_helper'

class MetachatTest < Test::Unit::TestCase
  def test_user_page_uri
    assert_equal "http://metachat.org/users/chrismear", Metachat.user_page_uri("chrismear").to_s
    assert_equal "http://metachat.org/users/It's%20Raining%20Florence%20Henderson", Metachat.user_page_uri("It's Raining Florence Henderson").to_s
  end
  
  def test_check_secret_mock
    Metachat.secret_check_succeed = true
    assert Metachat.check_secret("whatever", "doesn't matter")
    
    Metachat.secret_check_succeed = false
    assert !Metachat.check_secret("whatever", "doesn't matter")
  end
end