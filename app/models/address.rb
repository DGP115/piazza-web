class Address < ApplicationRecord
  include PermittedAttributes

  belongs_to :addressable, polymorphic: true

  validates :line_1, presence: true
  validates :line_2, presence: true
  validates :city, presence: true
  validates :subnational_division, presence: true
  validates :country, presence: true
  validates :postcode, presence: true

  def redacted
    "#{city}, #{postcode}"
  end
end
