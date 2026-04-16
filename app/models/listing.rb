class Listing < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :organization

  enum :condition, [ "mint", "near_mint", "used", "defective" ].index_by(&:itself)

  validates :title, length: { in: 10..100 }
  validates :price, numericality: { only_integer: true }
  validates :condition, presence: true
  # We want to ensure that there is at least 1 tag and at most 5 tags on a listing
  # i.e. the number given refers to the number of array elements, not the length of any element's string
  validates :tags, length: { in: 1..5 }

  normalizes :tags, with: ->(tags)  { tags.map(&:downcase) }
end
