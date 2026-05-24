class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens do |t|
      t.string :public_key, null: false
      t.string :private_key, null: false
      t.text :refresh_token, array: true, default: []
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
