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
  
  def test_should_have_sent_valentines_in_date_order
    assert_equal [valentines(:to_unconfirmed_bunny), valentines(:to_confirmed_bunny), valentines(:old_valentine_1)],
      bunnies(:chrismear).sent_valentines
  end
  
  def test_should_have_received_valentines_in_reverse_date_order
    assert_equal [valentines(:from_confirmed_bunny), valentines(:from_bob), valentines(:old_valentine_2), valentines(:old_valentine_1)],
      bunnies(:chrismear).received_valentines
  end
  
  def test_should_not_log_in_proto_bunny
    assert_nil Bunny.authenticate("proto", "")
    assert_nil Bunny.authenticate("proto", nil)
  end
  
  def test_should_be_able_to_create_a_proto_bunny
    assert_difference "Bunny.count" do
      bunny = Bunny.create_proto_bunny("newbunny")
      assert !bunny.new_record?
      assert bunny.crypted_password.blank?
      assert !bunny.salt.blank?
      assert_equal "newbunny", bunny.username
    end
  end
  
  def test_creating_a_proto_bunny_with_a_blank_username_should_fail
    assert_no_difference "Bunny.count" do
      bunny = Bunny.create_proto_bunny("")
      assert_nil bunny
    end
  end
  
  def test_should_not_be_able_to_mass_assign_proto_bunny_attribute
    b = Bunny.new(:username => "newbunny", :proto_bunny => true)
    assert_nil b.proto_bunny
  end
  
  def test_received_valentines_after
    bunny = bunnies(:chrismear)
    assert_equal [valentines(:old_valentine_2), valentines(:from_confirmed_bunny), valentines(:from_bob)],
      bunny.received_valentines_after(1)
  end
  
  def test_key_for_bunny_with_key
    assert_equal "0bd994c5927d45ca9ffd8be84a8e45973e4073b6", bunnies(:chrismear).key
  end
  
  def test_key_for_bunny_without_key
    b = bunnies(:bob)
    key = b.key
    assert !key.blank?
    b.reload
    assert_equal key, b.read_attribute(:key)
  end
  
  def test_received_valentines_for_year
    assert_equal [:old_valentine_2, :old_valentine_1].map{|n| valentines(n)},
      bunnies(:chrismear).received_valentines_for_year(2006)
  end
  
  def test_sent_valentines_for_year
    assert_equal [valentines(:old_valentine_1)],
      bunnies(:chrismear).sent_valentines_for_year(2006)
  end
  
  def test_update_by_username_or_new
    b = Bunny.update_by_username_or_new(:username => "chrismear", :password => "newpassword", :password_confirmation => "wrong")
    assert !b.new_record?
    assert_equal 1, b.id
    assert_equal "newpassword", b.password
    assert_equal "wrong", b.password_confirmation
    
    b = Bunny.update_by_username_or_new(:username => "newbunny", :password => "newpassword", :password_confirmation => "wrong")
    assert b.new_record?
    assert_equal "newpassword", b.password
    assert_equal "wrong", b.password_confirmation
  end
  
  def test_received_after
    b = bunnies(:chrismear)
    year = Time.now.utc.year
    
    assert_equal [valentines(:from_confirmed_bunny), valentines(:from_bob)],
      b.received_valentines_after(0, year)
    
    assert_equal [valentines(:old_valentine_1), valentines(:old_valentine_2), valentines(:from_confirmed_bunny), valentines(:from_bob)],
      b.received_valentines_after(0)
    
    assert_equal [valentines(:from_bob)],
      b.received_valentines_after(13)
    
    assert_equal [valentines(:from_bob)],
      b.received_valentines_after(13, year)
  end
  
  def test_count_sent_valentines_for_year
    assert_equal 2, bunnies(:chrismear).count_sent_valentines_for_year(Time.now.utc.year)
  end
  
  def test_count_received_valentines_for_year
    assert_equal 2, bunnies(:chrismear).count_received_valentines_for_year(Time.now.utc.year)
  end
  
  private
  
  def create_bunny(options={})
    Bunny.create({:username => "zombiebunny", :password => "letmein", :password_confirmation => "letmein"}.merge(options))
  end
end