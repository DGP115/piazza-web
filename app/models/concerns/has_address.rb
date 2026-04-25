module HasAddress
  extend ActiveSupport::Concern

  included do
    has_one :address, as: :addressable, dependent: :destroy
    validates :address, presence: true
    #  This enables forms to deal with attributes to two models
    #  [Listing and Address in this case]
    accepts_nested_attributes_for :address
  end
end
