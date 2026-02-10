require "application_system_test_case"

module Mobile
  class NavigationBarTest < MobileSystemTestCase
    test "can access sign up page via burger menu" do
      visit root_path

      # Because the hamburger menu button doesn't have a label, we use the Capybara
      # "finder" function to locate its css selector
      find(".navbar-burger").click
      click_on I18n.t("application.navbar.sign_up")

      assert_current_path sign_up_path
    end

    test "can access login page via burger menu" do
      visit root_path

      # Because the hamburger menu button doesn't have a label, we use the Capybara
      # "finder" function to locate its css selector
      find(".navbar-burger").click
      click_on I18n.t("application.navbar.login")

      assert_current_path login_path
    end
  end
end
