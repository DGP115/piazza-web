require "test_helper"

class User::PasswordResetTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @user = users(:jerry)
    ActionMailer::Base.deliveries.clear
  end

  test "1.  password reset destroys all sessions and sends reset email" do
    # create sessions
    @user.app_sessions.create
    @user.app_sessions.create

    @user.reset_password

    assert_emails 1
    assert_empty @user.app_sessions
  end

  test "2.  can retrieve a user with a valid password reset token" do
    token = @user.generate_token_for(:password_reset)

    user = User.find_by_token_for(:password_reset, token)

    assert_equal @user, user
  end

  test "3.  retrieving a user with an invalid token returns nil" do
    assert_nil User.find_by_token_for(:password_reset, "an_invalid_token")
  end

  test "4.  retrieving a user with an expired token returns nil" do
    token = @user.generate_token_for(:password_reset)
    travel_to 3.hours.from_now
    assert_nil User.find_by_token_for(:password_reset, token)
  end

  test "5.  retrieving a user with an outdated token returns nil" do
    @user.reset_password
    token = @user.generate_token_for(:password_reset)
    @user.update(password: "new_password")
    assert_nil User.find_by_token_for(:password_reset, token)
  end
end
