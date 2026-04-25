class ListingsController < ApplicationController
  before_action :load_listing, only: %i[ show edit update destroy ]
  allow_unauthenticated only: :show

  def new
    @listing = Listing.new
    # Recall:  the .build_"model_we_have_a_polymorphic_assocation_with" method
    #          is provided by Rails when we have a polymorphic association.
    #          It initializes the associated model and sets up the correct foreign keys and type.
    @listing.build_address
  end

  def create
    @listing = Listing.new(
      listing_params.with_defaults(
        creator: Current.user,
        organization: Current.organization
      )
    )

    if @listing.save
      redirect_to listing_path(@listing), status: :see_other
      flash[:success] = t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to listing_path(@listing), status: :see_other
      flash[:success] = t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to root_path, status: :see_other
    flash[:success] = t(".success")
  end

  private
    def listing_params
      # Note: a concern is referenced here to encapsulate the permitted attributes.
      # This is because a Listing includes an Address but other models could also
      # include an Address
      params.require(:listing).permit(Listing.permitted_attributes)
    end

    def load_listing
      @listing = Listing.find(params[:id])
    end
end
