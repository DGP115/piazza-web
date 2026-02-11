class Users::PasswordsController < ApplicationController
  def update
    @user = Current.user

    # assign_attributes is provided by ActiveRecord
    @user.assign_attributes(password_params)

    # Recall:  The authenticate concern has a special context "password_change" on its password validation
    # Recall:  This was to allow a user to change their name without entering password [Odd IMHO]
    if @user.save(context: :password_change)
      flash[:success] = t(".success")
      redirect_to profile_path, status: :see_other
    else
      render "users/show", status: :unprocessable_entity
    end
  end

  private

    def password_params
      params.require(:user).permit(
        :password,
        :password_challenge
      ).with_defaults(password_challenge: "")
    end
end
