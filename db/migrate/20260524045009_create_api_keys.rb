class CreateApiKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys do |t|
      t.string  :key, null: false
      t.boolean :status, null: false, default: true
      t.string :permissions, array: true, default: [], null: false

      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end
end
