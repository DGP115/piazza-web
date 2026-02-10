require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "new user can sign up" do
    visit root_path

    click_on I18n.t("application.navbar.sign_up")
    # A way to have Capybara do something to allow time for the form to build
    # assert_field "Name"
    assert_selector "input#user_name", wait: 10

    fill_in User.human_attribute_name(:name), with: "Newman"
    fill_in User.human_attribute_name(:email), with: "newman@example.com"
    fill_in User.human_attribute_name(:password), with: "short"
    fill_in User.human_attribute_name(:password_confirmation), with: "short"

    click_on I18n.t("users.new.sign_up")
    assert_selector "p.is-danger",
      text: I18n.t("errors.messages.too_short", count: 8)

    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"
    click_on I18n.t("users.new.sign_up")

    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("users.create.welcome", name: "Newman")
    # To verify the user is logged in, check that the dropdown menu is present.  "Visible" is false because
    # the menu only appears when the user mouses over it.
    assert_selector ".navbar-dropdown", visible: false
  end

  test "existing user can log in" do
    # Note:  Use a user from the fixtures
    visit root_path

    # click_on I18n.t("application.navbar.login")
    click_on "Login"
    # A way to have Capybara do something to allow time for the form to build
    # assert_field "Email"
    assert_selector "input#user_email", wait: 5

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "wrong"
    uncheck I18n.t("sessions.new.remember_me")

    click_on I18n.t("sessions.new.submit_button")
    assert_selector ".notification.is-danger", text: I18n.t("sessions.create.incorrect_details")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    uncheck I18n.t("sessions.new.remember_me")

    click_on I18n.t("sessions.new.submit_button")
    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("sessions.create.success")
    # To verify the user is logged in, check that the dropdown menu is present.  "Visible" is false because
    # the menu only appears when the user mouses over it.
    assert_selector ".navbar-dropdown", visible: false
  end
end
