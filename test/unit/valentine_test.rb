require File.dirname(__FILE__) + '/../test_helper'

class ValentineTest < Test::Unit::TestCase
  fixtures :valentines, :bunnies
  
  def test_should_have_sender
    assert_equal bunnies(:chrismear), valentines(:to_confirmed_bunny).sender
  end
  
  def test_should_have_recipient
    assert_equal bunnies(:confirmed_bunny), valentines(:to_confirmed_bunny).recipient
  end
  
  def test_should_be_able_to_create_valentine
    assert_difference Valentine, :count do
      valentine = create_valentine
      assert !valentine.new_record?
    end
  end
  
  def test_should_require_message
    assert_no_difference Valentine, :count do
      valentine = create_valentine(:message => "")
      assert valentine.errors.on(:message)
    end
  end
  
  def test_should_require_sender
    assert_no_difference Valentine, :count do
      valentine = create_valentine(:sender => nil)
      assert valentine.errors.on(:sender)
    end
  end
  
  def test_should_require_recipient
    assert_no_difference Valentine, :count do
      valentine = create_valentine(:recipient => nil)
      assert valentine.errors.on(:recipient)
    end
  end
  
  def test_should_set_created_at_on_create
    valentine = create_valentine
    assert valentine.created_at
  end
  
  private
  
  def create_valentine(options={})
    Valentine.create({:message => "I choo-choo-choose you!", :sender => bunnies(:chrismear), :recipient => bunnies(:confirmed_bunny)}.merge(options))
  end
end
