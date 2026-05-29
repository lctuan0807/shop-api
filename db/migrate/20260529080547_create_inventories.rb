class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.string  :location, default: "unknown"
      t.integer :stock, null: false
      t.integer :product_id, null: false
      t.integer :shop_id, null: false
      t.text    :reservations, array: true, default: []

      t.timestamps
    end
  end
end
