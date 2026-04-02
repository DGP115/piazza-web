class AddConditionEnumToListings < ActiveRecord::Migration[8.1]
  def change
    # Note:  postgresql supports an enum data type
    create_enum :listing_condition, [ :mint, :near_mint, :used, :defective ]

    change_table :listings do |t|
      t.enum :condition, enum_type: :listing_condition
    end
  end
end
