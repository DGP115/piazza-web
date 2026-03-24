require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:jerry)

    # In the test environment, Action Mailer delivers emails to the ActionMailer::Base.deliveries array
    # instead of actually sending them. That’s why we clear it before the test starts.
    ActionMailer::Base.deliveries.clear
  end

  test "password reset" do
    # The with method is how parameters are passed to a mailer.
    email = UserMailer
              .with(user: @user)
              .password_reset
              .deliver_now

    assert_match @user.name, email[:to].unparsed_value
    assert_match @user.email, email[:to].unparsed_value

    assert_select_email do
      assert_select "a.button"
    end
  end
end
