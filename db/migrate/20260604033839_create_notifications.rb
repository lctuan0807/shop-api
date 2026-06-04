class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.string :kind, null: false
      t.integer :sender_id, null: false
      t.string :sender_type, null: false
      t.integer :receiver_id, null: false
      t.string :content, null: false
      t.jsonb :options, default: {}

      t.timestamps
    end
  end
end
