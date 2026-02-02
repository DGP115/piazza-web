class User < ApplicationRecord
  validates :name, presence: true
  validates :email,
             format: { with: URI::MailTo::EMAIL_REGEXP },
             uniqueness: { case_sensitive: false }

  # With has_secure_password, Rails dynamically defines a number of instance methods including
  # authenticate_token(unencrypted)
  has_secure_password

  validates :password, presence: true, length: { minimum: 8 }

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  has_many :app_sessions

  def self.create_app_session(email:, password:)
    # We use authenticate_by to retrieve and authenticate the user against the password.
    # This method cryptographically digests the password regardless of
    # whether a User record is found. This mitigates timing-based enumeration
    # attacks using which an attacker could determine whether or not a User
    # exists in the system without knowing the password.
    user = User.authenticate_by(email: email, password: password)
    # Maintain a record of all user app_sessions in a collection
    user.app_sessions.create if user.present?
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)

  rescue ActiveRecord::RecordNotFound
    nil
  end
end
