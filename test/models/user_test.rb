require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "John Brown", email: "john@brown.com", password: "password", password_confirmation: "password")
  end

  test "user is valid" do
    # correct user
    user = User.new(name: "John Brown", email: "john@brown.com", password: "password")
    assert user.valid?
    # user without name
    user2 = User.new(name: "", email: "random@email.com", password: "password")
    assert_not user2.valid?
    # user without email
    user3 = User.new(name: "John Brown", email: "")
    assert_not user3.valid?
    # user with too long name
    user4 = User.new(name: "a"*31, email: "john@brown.com", password: "password")
    assert_not user4.valid?
    # user with too long email
    user4 = User.new(name: "John Brown", email: "a"*256+"@gmail.com", password: "password")
    assert_not user4.valid?
  end

  test "saving user to database" do
    # can save correct user
    user = User.new(name: "John Brown", email: "john@brown.com", password: "password")
    assert_difference 'User.count', 1 do
      user.save!
    end
    # user is unique, cannot save the same email
    user.save!
    duplicate_user = user
    assert_no_difference 'User.count' do
      duplicate_user.save!
    end
    # user's email is case sensitive
    email_upcase = user.email.upcase
    duplicate_user.email = email_upcase
    assert_no_difference 'User.count' do
      duplicate_user.save!
    end
    assert_not_equal user.reload.email, email_upcase
  end

  test "password shuld equal password_confirmation" do
    assert_equal @user.password, @user.password_confirmation
  end

  test "password should be long enough" do
    @user.password = @user.password_confirmation = "123"
    assert_not @user.valid?
  end  
end
