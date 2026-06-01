class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.jsonb :checkout
      t.jsonb :shipping
      t.jsonb :payment
      t.jsonb :products
      t.string :tracking_number
      t.string :status

      t.timestamps
    end
  end
end
