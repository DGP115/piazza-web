class UserMailer < ApplicationMailer
  before_action :set_user

  # The "To" field of the email to be sent.
  default to: -> { %("{#{@user.name}}" <#{@user.email}>) }

  # The "From" is set in application_mailer.rb
  # The subject is set below and
  # the body of the email is set in the view file app/views/user_mailer/password_reset.html.erb
  # The token is maide avaiolable to the view by setting the @variable below.
  # This allows the button in the view to forward the token to the password_resets_controller

  def password_reset(token)
    @password_reset_token = token

    #  Note:  only the subject: needs to be passed in as the defined defaults
    #  are fine for everything else.
    #  Recall:  default from: set in ApplicationMailer
    mail subject: t(".subject")
  end

  private

  def set_user
    @user = params[:user]
  end
end
