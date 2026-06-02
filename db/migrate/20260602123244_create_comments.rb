class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :user_id, null: false
      t.text :content, null: false
      t.boolean :is_deleted, null: false, default: false
      t.integer :lft, null: false
      t.integer :rgt, null: false
      t.integer :parent_id
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0

      t.timestamps
    end

    add_index :comments, :lft
    add_index :comments, :rgt
    add_index :comments, :parent_id
  end
end
