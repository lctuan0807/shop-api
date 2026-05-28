class AddingUniqueIndexToProductSlug < ActiveRecord::Migration[7.2]
  def change
    add_index :products, :slug, unique: true
  end
end
