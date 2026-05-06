require "test_helper"

class PaginationHelperTest < ActionView::TestCase
  # The below is necessary to enable access to the page_needed? helper method.
  include ApplicationHelper

  setup do
    @turbo_native_app = false
  end
  test "pagy_needed? returns false when @pagy is nil" do
    @pagy = nil
    assert_not pagy_needed?
  end

  test "pagy_needed? returns false when there is only one page" do
    # Ruby Struct is used to create a mock @pagy object.  This is a convenient way
    # to create ad-hoc objects
    @pagy = Struct.new(:pages).new(1)
    assert_not pagy_needed?
  end

  test "pagy_needed? returns true when there are multiple pages" do
    # Ruby Struct is used to create a mock @pagy object.  This is a convenient way
    # to create ad-hoc objects
    @pagy = Struct.new(:pages).new(3)
    assert pagy_needed?
  end

  test "pagy_needed? returns false for turbo native app" do
    @turbo_native_app = true
    # Ruby Struct is used to create a mock @pagy object.  This is a convenient way
    # to create ad-hoc objects
    @pagy = Struct.new(:pages).new(3)
    assert_not pagy_needed?
  end

  private

    def turbo_native_app?
      @turbo_native_app
    end
end
