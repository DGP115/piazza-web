require "test_helper"

class ListingTest < ActiveSupport::TestCase
  setup do
    @user = users(:jerry)
    @listing = listings(:auto_listing_1_jerry)
  end

  test "tags are downcased before saving" do
    @listing.tags = [ "Tag1", "TAG2", "tag3" ]
    @listing.save!
    assert_equal [ "tag1", "tag2", "tag3" ], @listing.reload.tags
  end
end
