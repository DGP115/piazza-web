class AppSession < ApplicationRecord
  belongs_to :user

  # With has_secure_password, Rails dynamically defines a number of instance methods including
  # authenticate_token(unencrypted)
  has_secure_password :token, validations: false

  # "generate_unique_secure_token" is provided by ActiveRecord
  before_create {
    self.token = self.class.generate_unique_secure_token
  }

  def to_hash
    {
      user_id: user_id,
      app_session: id,
      token: self.token
    }
  end
end
