class AddingNewProductColumns < ActiveRecord::Migration[7.2]
  def change
    return unless table_exists?(:products)
    
    add_column :products, :slug, :string
    add_column :products, :average_rating, :decimal, precision: 2, scale: 1, default: 4.5, null: false
    add_column :products, :variations, :jsonb, default: []
    add_column :products, :is_draft, :boolean, default: true, null: false
    add_column :products, :is_published, :boolean, default: false, null: false

    add_index :products, :is_draft
    add_index :products, :is_published
  end
end
