module Authenticate
  extend ActiveSupport::Concern

  # ActiveSupport::Concern has a "included" method that takes a block
  # which is executed when it’s included in a class. Using this method, define a
  # callback to invoke "authenticate"
  included do
    # before_action callbacks will run before every controller action
    before_action :authenticate
    before_action :require_login, unless: :logged_in?

    # "helper method" makes the logged_in? method available to views
    helper_method :logged_in?
  end

  # To allow exceptions where we can skip authentication:
  # These methods need to be class methods so a controller can invoke them in the same way as
  # callbacks. To accomplish this, use ActiveSupport::Concern's class_methods directive
  # which takes a block and adds those methods to the host class as class methods.
  class_methods do
    def skip_authentication(**options)
      skip_before_action :authenticate, options
      skip_before_action :require_login, options
    end

    def allow_unauthenticated(**options)
      skip_before_action :require_login, options
    end
  end

  protected

  def logged_in?
    Current.user.present?
  end

  # Using a Rails helper to store the user's session data.  If the user checks "rememer me" the session is
  # stoted in an encrypted cookie.  It’s also chained with the permanent cookie jar meaning the cookie will
  # live for 20 years. This way, the user won’t be logged out if they close the browser or
  # the app.
  # If "remember_me" is not checked, the cookie expires when the session does.
  def log_in(app_session, remember_me)
    if remember_me
      cookies.encrypted.permanent[:app_session] = {
        value: app_session.to_hash
      }
    else
      cookies.encrypted[:app_session] = {
        value: app_session.to_hash
      }
    end
  end

  def log_out
    Current.app_session&.destroy
  end


  private

    def authenticate
      Current.app_session = authenticate_using_cookie
      Current.user = Current.app_session&.user
    end

    # This method extracts the data from the encrypted cookie and while passing
    # it to the authenticate_using method, it converts it to a hash with
    # indifferent access. This means values can be retrieved using both the string
    # and symbol version of the key.
    def authenticate_using_cookie
      app_session = cookies.encrypted[:app_session]
      authenticate_using(app_session&.with_indifferent_access)
    end

    def authenticate_using(data)
      # decontsruct the provided hash into constituent data values.
      # Id deconstruction can't occur, ruby generates a NoMatchingPatternError,
      # so the rescue is invoked and nil is returned
      data => { user_id:, app_session:, token: }

      # The User object is used to authenticate the app_session and token,
      # returning an AppSession instance if it succeeds and nil if it doesn’t
      # (by returning error ActiveRecord::RecordNotFound, this invoking the rescue).
      user = User.find(user_id)
      user.authenticate_app_session(app_session, token)

    rescue NoMatchingPatternError, ActiveRecord::RecordNotFound
      nil
    end

    def require_login
      flash.now[:notice] = t("login_required")
      render "sessions/new", status: :unauthorized
    end
end
