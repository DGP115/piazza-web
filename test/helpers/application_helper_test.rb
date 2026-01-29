require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "page-specific title displayed if it exists" do
    content_for(:title) { "Page Title" }
    assert_equal "Page Title | #{I18n.t('piazza')}", title
  end

  test "app title used when page title is missing" do
    assert_equal I18n.t("piazza"), title
  end
end
