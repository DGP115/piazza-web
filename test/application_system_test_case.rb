require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # [ 1400, 1400 ] corresponds to a desktop PC
  WINDOW_SIZE = [ 1400, 1400 ]
  driven_by :selenium, using: :headless_chrome, screen_size: WINDOW_SIZE

  Capybara.server_host = "localhost"
  Capybara.app_host = "http://localhost"

  private
    # A helper method for user logins
    def log_in(user, password: "password")
      visit login_path

      fill_in User.human_attribute_name(:email), with: user.email
      fill_in User.human_attribute_name(:password), with: password

      click_button I18n.t("sessions.new.submit_button")

      assert_selector "#current_user_name", text: user.name
    end
end

class MobileSystemTestCase < ApplicationSystemTestCase
  setup do
    visit root_path
    current_window.resize_to(375, 812)
  end

  teardown do
    current_window.resize_to(*ApplicationSystemTestCase::WINDOW_SIZE)
  end
end
