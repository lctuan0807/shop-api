class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true
      t.integer :quantity
      t.datetime :expired_at

      t.timestamps
    end

    add_index :reservations, [:inventory_id, :cart_id], unique: true
  end
end
