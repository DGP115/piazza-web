class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :title
      t.integer :price, null: false
      t.references :organization, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
