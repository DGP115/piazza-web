require "test_helper"

class AddressTest < ActiveSupport::TestCase
  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
    @address = addresses(:auto_listing_1_jerry_address)
  end

  test "address must have line_1" do
    @address.line_1 = nil
    assert_no_difference "Listing.count" do
      @listing.save
    end
  end

  test "address must have line_2" do
    @address.line_2 = nil
    assert_no_difference "Listing.count" do
      @listing.save
    end
  end

  test "address must include city" do
    @address.city = nil
    assert_no_difference "Listing.count" do
      @listing.save
    end
  end

  test "address must include subnational_division" do
    @address.subnational_division = nil
    assert_no_difference "Listing.count" do
      @listing.save
    end
  end

  test "address must include country" do
    @address.country = nil
    assert_no_difference "Listing.count" do
      @listing.save
    end
  end
end
