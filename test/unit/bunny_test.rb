require File.dirname(__FILE__) + '/../test_helper'

class BunnyTest < Test::Unit::TestCase
  fixtures :bunnies, :valentines
  
  def test_should_create_bunny
    assert_difference "Bunny.count" do
      bunny = create_bunny
      assert !bunny.new_record?
    end
  end
  
  def test_should_require_username
    assert_no_difference "Bunny.count" do
      bunny = create_bunny(:username => "")
      assert bunny.errors.on(:username)
    end
  end
  
  def test_should_require_password
    assert_no_difference "Bunny.count" do
      bunny = create_bunny(:password => nil)
      assert bunny.errors.on(:password)
    end
  end
  
  def test_should_require_password_confirmation
    assert_no_difference "Bunny.count" do
      bunny = create_bunny(:password_confirmation => "")
      assert bunny.errors.on(:password_confirmation)
    end
  end
  
  def test_should_require_password_confirmation_to_be_the_same_as_the_password
    assert_no_difference "Bunny.count" do
      bunny = create_bunny(:password_confirmation => "something else")
      assert bunny.errors.on(:password)
    end
  end
  
  def test_should_be_able_to_reset_password
    bunnies(:chrismear).update_attributes(:password => "new_password", :password_confirmation => "new_password")
    assert_equal bunnies(:chrismear), Bunny.authenticate("chrismear", "new_password")
  end
  
  def test_should_be_able_to_update_other_attributes_without_rehashing_password
    bunnies(:chrismear).update_attributes(:username => "mearca")
    assert_equal bunnies(:chrismear), Bunny.authenticate("mearca", "qwerty")
  end
  
  def test_should_allow_log_in
    bunny = Bunny.authenticate("chrismear", "qwerty")
    assert_equal bunnies(:chrismear), bunny
  end
  
  def test_should_fail_log_in
    bunny = Bunny.authenticate("chrismear", "wrong_password")
    assert_nil bunny
    
    bunny = Bunny.authenticate("non_existent_user", "random_password")
    assert_nil bunny
    
    bunny = Bunny.authenticate("chrismear", "")
    assert_nil bunny
  end
  
  def test_should_have_sent_valentines
    assert_equal [valentines(:to_unconfirmed_bunny), valentines(:to_confirmed_bunny)],
      bunnies(:chrismear).sent_valentines
  end
  
  def test_should_have_received_valentines
    assert_equal [valentines(:from_confirmed_bunny), valentines(:from_bob)],
      bunnies(:chrismear).received_valentines
  end
  
  def test_should_not_log_in_automatically_created_bunny
    assert_nil Bunny.authenticate("automatic", "")
    assert_nil Bunny.authenticate("automatic", nil)
  end
  
  private
  
  def create_bunny(options={})
    Bunny.create({:username => "zombiebunny", :password => "letmein", :password_confirmation => "letmein"}.merge(options))
  end
end