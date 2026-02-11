require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "new user can sign up" do
    visit sign_up_path

    # click_on I18n.t("application.navbar.sign_up")
    # # Click the Sign Up button (matches visible text in navbar)

    # assert_current_path sign_up_path
    # Wait until the form appears
    assert_selector "input#user_name", wait: 15

    # Fill in the form with invalid password first
    fill_in User.human_attribute_name(:name), with: "Newman"
    fill_in User.human_attribute_name(:email), with: "newman@example.com"
    fill_in User.human_attribute_name(:password), with: "short"
    fill_in User.human_attribute_name(:password_confirmation), with: "short"

    click_on I18n.t("users.new.sign_up")

    # Check for error about password being too short
    assert_selector ".help.is-danger",
      text: I18n.t("activerecord.errors.models.user.attributes.password.too_short", count: 8)

    # Correct the password
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

    # visit root_path
    visit login_path

    # click_on I18n.t("application.navbar.login")
    # click_on "Login"
    # Wait for form fields to appear"
    assert_selector "input#user_email", wait: 15

    # Fill in invalid credentials first
    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "wrong"
    uncheck I18n.t("sessions.new.remember_me")

    # Check for error notification
    # click_on I18n.t("sessions.new.submit_button")
    click_button I18n.t("sessions.new.submit_button")
    assert_selector ".notification.is-danger", text: I18n.t("sessions.create.incorrect_details"), wait: 5

    # Fill in correct credentials
    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    uncheck I18n.t("sessions.new.remember_me")

    # click_on I18n.t("sessions.new.submit_button")
    click_button I18n.t("sessions.new.submit_button")

    # Confirm redirect to root and success message
    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("sessions.create.success")
    # To verify the user is logged in, check that the dropdown menu is present.  "Visible" is false because
    # the menu only appears when the user mouses over it.
    assert_selector ".navbar-dropdown", visible: false
  end
  test "user can update name" do
    # Use system test helper method to log in
    log_in(users(:jerry))

    visit profile_path

    fill_in User.human_attribute_name(:name), with: "Jerry Seinfeld"
    click_button I18n.t("users.show.save_profile")

    # assert_selector "form .notification", text: I18n.t("users.update.success")

    assert_field "user_name", with: "Jerry Seinfeld"
  end
end
