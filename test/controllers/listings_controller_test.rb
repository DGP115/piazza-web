require "test_helper"
class ListingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
    @address = addresses(:auto_listing_1_jerry_address)
    log_in @user
  end


  test "can create a listing" do
    assert_difference "Listing.count", 1 do
      post listings_path, params: {
        listing: {
          title: Faker::Commerce.product_name,
          price: Faker::Commerce.price.floor,
          condition: Listing.conditions.keys.sample,
          tags: [ "cars" ],
          address_attributes: @address.attributes.slice(
            "line_1",
            "line_2",
            "city",
            "subnational_division",
            "country",
            "postcode"
          )
        }
      }
    end
  assert_redirected_to listing_path(Listing.last)
  end

  test "error when creating an invalid listing" do
    assert_no_difference "Listing.count" do
      post listings_path, params: {
        listing: {
          title: "title",
          price: 300,
          condition: Listing.conditions.keys.sample,
          tags: [ "cars" ],
          address_attributes: @address.attributes.slice(
            "line_1",
            "line_2",
            "city",
            "subnational_division",
            "country",
            "postcode"
        )
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select "p.is-danger"
  end

  test "can update a listing" do
    @listing = listings(:auto_listing_1_jerry)
    new_title = Faker::Commerce.product_name
    patch listing_path(@listing), params: {
      listing: {
        title: new_title,
        price: @listing.price,
        condition: Listing.conditions.keys.sample,
        tags: [ "cars" ],
        address_attributes: @address.attributes.slice(
            "id",
            "line_1",
            "line_2",
            "city",
            "subnational_division",
            "country",
            "postcode"
        )
      }
    }
    assert_redirected_to listing_path(@listing)
    assert_equal new_title, @listing.reload.title
  end

  test "error when updating a listing with invalid data" do
    @listing = listings(:auto_listing_1_jerry)
    patch listing_path(@listing), params: {
      listing: {
        title: @listing.title,
        price: "NaN",
        condition: Listing.conditions.keys.sample,
        tags: [ "cars" ],
        address_attributes: @address.attributes.slice(
          "id",
          "line_1",
          "line_2",
          "city",
          "subnational_division",
          "country",
          "postcode"
        )
      }
    }
    assert_response :unprocessable_entity
  end

  test "can delete a listing" do
    @listing = listings(:auto_listing_1_jerry)
    assert_difference "Listing.count", -1 do
      delete listing_path(@listing)
    end
    assert_redirected_to my_listings_path
  end

  test "listing title length validation.too short" do
    assert_no_difference "Listing.count" do
      post listings_path, params: {
        listing: {
          title: "123",
          price: Faker::Commerce.price.floor,
          condition: Listing.conditions.keys.sample,
          tags: [ "cars" ],
          address_attributes: @address.attributes.slice(
            "line_1",
            "line_2",
            "city",
            "subnational_division",
            "country",
            "postcode"
          )
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select "p.is-danger"
  end

  test "listing title length validation.too long" do
    assert_no_difference "Listing.count" do
      post listings_path, params: {
        listing: {
          title:  "a" * 101,
          price: Faker::Commerce.price.floor,
          condition: Listing.conditions.keys.sample,
          tags: [ "cars" ],
          address_attributes: @address.attributes.slice(
              "line_1",
              "line_2",
              "city",
              "subnational_division",
              "country",
              "postcode"
            )
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select "p.is-danger"
  end
end
