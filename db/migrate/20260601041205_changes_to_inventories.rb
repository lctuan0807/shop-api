class ChangesToInventories < ActiveRecord::Migration[7.2]
  def change
    add_index :inventories, [:shop_id, :product_id], unique: true
    change_column_default :inventories, :stock, from: nil, to: 0
    remove_column :inventories, :reservations if column_exists?(:inventories, :reservations)
  end
end
