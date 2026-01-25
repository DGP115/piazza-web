require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "user requres a name" do
    @user = User.new(name: "", email: "user1@example.com", password: "password")
    assert_not @user.valid?

    @user.name = "user1"
    assert @user.valid?
  end

  test "user requires an email" do
    @user = User.new(name: "user1", email: "", password: "password")
    assert_not @user.valid?

    @user.email = "user1@example.com"
    assert @user.valid?
  end

  test "email must be unique" do
    @existing_user = User.create(name: "user1", email: "u1@example.com", password: "password")
    assert @existing_user.persisted?

    @user = User.new(name: "u1", email: "u1@example.com", password: "password")
  end

  test "name and email is stripped of unnecessary spaces before saving" do
    @user = User.new(name: "  user1  ", email: "  user1@example.com  ", password: "password")
    assert_equal "user1", @user.name
    assert_equal "user1@example.com", @user.email
  end

  test "password length between 8 and ActiveModel's maximum" do
    @user = User.new(name: "user1", email: "user1@example.com", password: "a")
    assert_not @user.valid? # too short

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid? # too long
  end
end
