class CreateTableOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.decimal :total_price, null: false
      t.decimal :total_discount, null: false
      t.decimal :shipping_fee, null: false
      t.decimal :total_checkout, null: false

      t.timestamps
    end
  end
end
