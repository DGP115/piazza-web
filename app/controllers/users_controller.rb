class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Recall, members is a collection so create action takes an array as input.
      @organization = Organization.create(members: [ @user ])
      #
      # TODO: Add user login after signup.

      redirect_to root_path,
        status: :see_other,
        flash: { success: t(".welcome", name: @user.name) }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # The check of password=password_confirmation is automatically handled by has_secure_password
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
