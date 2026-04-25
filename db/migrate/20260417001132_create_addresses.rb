class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      # will create columns: addressable_type and addressable_id
      # Using this technique, an Address can be associated with any other model
      t.references :addressable, polymorphic: true

      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :subnational_division
      t.string :country
      t.string :postcode
      
      t.timestamps
    end
  end
end
