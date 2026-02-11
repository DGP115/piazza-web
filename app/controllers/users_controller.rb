class UsersController < ApplicationController
  skip_authentication only: %i[ new create ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Recall, members is a collection so create action takes an array as input.
      @organization = Organization.create(members: [ @user ])

      # For convenience, log the new user into the app right after successful sign up.
      @app_session = @user.app_sessions.create
      log_in(@app_session, remember_me: false)

      redirect_to root_path,
        status: :see_other,
        flash: { success: t(".welcome", name: @user.name) }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = Current.user
  end

  def edit
  end

  def update
    @user = Current.user

    if @user.update(update_params)
      flash[:success] = t(".success")
      redirect_to profile_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # The check of password=password_confirmation is automatically handled by has_secure_password
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
