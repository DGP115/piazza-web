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

  test "can create a session with email and correct password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "password"
    )
    assert_not_nil @app_session
    assert_not_nil @app_session.token
  end

  test "can not create a session with email and incorrect password" do
    @app_session = User.create_app_session(
      email: "jerry@example.com",
      password: "wrong_password"
    )
    assert_nil @app_session
  end

  test "can not create a session with non-existant user email" do
    @app_session = User.create_app_session(
      email: "not_jerry@example.com",
      password: "password"
    )
    assert_nil @app_session
  end

  test "can authenticate with a valid session id and token" do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

   assert_equal @app_session,
                @user.authenticate_app_session(@app_session.id, @app_session.token)
  end

  test "trying to authenticate with a token that doesn't exist returns false" do
    @user = users(:jerry)
    assert_not @user.authenticate_app_session(50, "token")
  end
end
