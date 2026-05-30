class RemoveProductIdsColumn < ActiveRecord::Migration[7.2]
  def change
    remove_column :discounts, :product_ids
  end
end
