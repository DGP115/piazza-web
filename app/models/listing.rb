class Listing < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :organization

  enum :condition, [ "mint", "near_mint", "used", "defective" ].index_by(&:itself)

  validates :title, length: { in: 10..100 }
  validates :price, numericality: { only_integer: true }
  validates :condition, presence: true
end
