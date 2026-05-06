class FeedController < ApplicationController
  allow_unauthenticated

  def show
    #  Recall:  "feed" is a scope defined for listings model, which orders
    #  listings by created_at in descending order
    @pagy, @listings = pagy(:offset, Listing.feed, limit: 20, slots: 5)
  end
end
