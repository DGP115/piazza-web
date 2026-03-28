# This is a concern to encapsulate the user password reset logic
module User::PasswordReset
  extend ActiveSupport::Concern

  # Note:  The `included` block is a special method provided by ActiveSupport::Concern that allows you
  # to define code that will be executed when the module is included in a class.
  # In this case, we are defining a token generation method for password resets.
  included do
    # The token is a random string that is generated when a user requests a password reset.
    # Specifically ":password_reset" is the name of the token, and it is used to generate a unique token for each
    # potential purpose, that is, you could also generate token for name cgnaged etc..
    # It is used to verify the identity of the user when they click on the password reset link in their email.
    # We also pass in the last 10 characters of the password’s salt which is included in the token alongside the
    # record’s ID. This way, when the password changes, the token is no longer valid.
    generates_token_for :password_reset, expires_in: 2.hours do
      password_salt.last(10)
    end
  end

  def reset_password
    # Destroy all sessions for the user to ensure that they are logged out of all devices.
    app_sessions.destroy_all

    send_password_reset_email
  end

  private
    def send_password_reset_email
      token = generate_token_for(:password_reset)

      UserMailer.with(user: self)
                .password_reset(token)
                .deliver_now
    end
end
