class UserMailer < ApplicationMailer
  before_action :set_user

  default to: -> { %("{#{@user.name}}" <#{@user.email}>) }

  def password_reset
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
