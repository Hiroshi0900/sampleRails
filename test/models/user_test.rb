require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
	@user = User.new(name:"example User",email:'email@mail.co.jp',
	                 password:"aaaa0000",password_confirmation:"aaaa0000")
  end

  test "name should be present" do
	@user.name = "  "
	assert_not @user.valid?
  end

  test "email should be present" do
	@user.email = "   "
	assert_not @user.valid?
  end

  test "name should not be too long" do
	  @user.name = "a"*51
	  assert_not @user.valid?
  end
  test "email should not be too long" do
	@user.email = "a"*244 + "@example.com"
	assert_not @user.valid?
  end

  test "email address should be unique" do 
	duplicate_user = @user.dup
	@user.save
	assert_not duplicate_user.valid?
  end
end
