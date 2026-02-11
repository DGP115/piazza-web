module AuthenticationHelpers
  # Since most controller tests will need a logged in user
  def log_in(user, password: "password")
    post login_path, params: {
      user: {
        email: user.email,
        password: password
      }
    }
  end

  # This helper function triggers a user logout to help test the logout functionality.
  def log_out
    delete logout_path
  end
end
