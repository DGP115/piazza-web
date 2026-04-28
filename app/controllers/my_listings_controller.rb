class MyListingsController < ApplicationController
  def show
    @pagy, @listings = pagy(Current.organization.listings.order(created_at: :desc))
  end
end
