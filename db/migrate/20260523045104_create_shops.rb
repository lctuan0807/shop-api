class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :email
      t.string :password_digest, null: false
      t.string :status, default: "inactive"
      t.boolean :verify, default: false
      t.text :roles, array: true, default: []

      t.timestamps
    end

    add_index :shops, :email, unique: true
  end
end
