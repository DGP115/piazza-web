module User::Authentication
  extend ActiveSupport::Concern

  included do
    # With has_secure_password, Rails dynamically defines a number of instance methods including
    # authenticate_token(unencrypted)
    has_secure_password

    # Rails validations can be restricted to certain contexts. The context(s) are
    # specified by supplying an on: option in the validates directive.
    # For example, only validate password on the creation of a record or changing of password
    validates :password,
      on: %i[ create password_change ],
      presence: true,
      length: { minimum: 8 }

    has_many :app_sessions
  end

  class_methods do
    def create_app_session(email:, password:)
      # authenticate_by is provided by Rails (in "comes with" 'has_secure_password').
      # This method cryptographically digests the password regardless of
      # whether a User record is found. This mitigates timing-based enumeration
      # attacks using which an attacker could determine whether or not a User
      # exists in the system without knowing the password.
      user = User.authenticate_by(email: email, password: password)
      # Maintain a record of all user app_sessions in a collection
      user.app_sessions.create if user.present?
    end
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)

  rescue ActiveRecord::RecordNotFound
    nil
  end
end
