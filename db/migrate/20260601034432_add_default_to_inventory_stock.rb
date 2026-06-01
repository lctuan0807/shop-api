class AddDefaultToInventoryStock < ActiveRecord::Migration[7.2]
  def change
    change_column_default :inventories, :stock, 0
  end
end
