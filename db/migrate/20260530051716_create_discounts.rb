class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.string        :name, null: false                                # Discount name
      t.string        :description, null: false                         # Discount description
      t.string        :kind, null: false, default: 'fixed'              # Discount kind (fixed, percentage)
      t.decimal       :value, null: false, precision: 10, scale: 2     # Discount value
      t.string        :code, null: false                                # Discount code
      t.datetime      :start_date, null: false                          # Discount start date
      t.datetime      :end_date, null: false                            # Discount end date
      t.integer       :max_uses, null: false                            # Maximum uses
      t.integer       :uses_count, null: false, default: 0              # Current uses count
      t.text          :uses_used, array: true, default: []              # Users who have used this discount
      t.integer       :max_uses_per_user, null: false, default: 0       # Maximum uses per user
      t.decimal       :min_order_value, precision: 10, scale: 2        # Minimum order value
      t.decimal       :max_order_value, precision: 10, scale: 2        # Maximum order value
      t.references    :shop, null: false, foreign_key: true             # Shop that owns this discount
      t.boolean       :is_active, null: false, default: true            # Whether the discount is active
      t.string        :applies_to, null: false, default: 'all_products' # What the discount applies to (all_products, specific_products, etc.)
      t.text          :product_ids, array: true, default: []            # Product IDs that this discount applies to

      t.timestamps
    end

    add_index :discounts, [:shop_id, :code], unique: true
  end
end
