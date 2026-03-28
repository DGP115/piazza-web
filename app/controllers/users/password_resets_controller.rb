class Users::PasswordResetsController < ApplicationController
  # When resetting their password, users won't be logging in, skip authentication for this controller
  skip_authentication

  before_action :load_user, only: %i[ edit update ]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      # Recall the reset_password method is defined in the user model concern for password resets
      user.reset_password
      flash[:success] = t(".password_reset_instructions_sent")
      redirect_to root_path
    else
      flash.now[:danger] = t(".email_not_found")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Recall:  assign_attrbiutes comes from ruby
    @user.assign_attributes(password_reset_params)

    if @user.save(context: :password_reset)
      # After resetting their password, log the user in and redirect to the homepage
      @app_session = @user.app_sessions.create
      log_in(@app_session, remember_me: false)

      redirect_to root_path, status: :see_other
      flash[:success] = t(".password_reset_successful")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def load_user
      @user = User.find_by_token_for(:password_reset, params[:id])

      if !@user.present?
        redirect_to new_users_password_reset_path, status: :see_other
        flash[:error] = t("users.password_resets.invalid__link")
      end
    end

    def password_reset_params
      params.require(:user).permit(:password)
    end
end
