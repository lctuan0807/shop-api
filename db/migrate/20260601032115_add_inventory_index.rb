class AddInventoryIndex < ActiveRecord::Migration[7.2]
  def change
    add_index :inventories, [:shop_id, :product_id], unique: true
  end
end
