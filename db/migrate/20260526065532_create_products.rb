class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string      :name,       null: false
      t.string      :thumbnail,  null: false
      t.text        :description
      t.decimal     :price,      null: false
      t.integer     :quantity,   null: false
      t.string      :category,       null: false
      t.references  :shop,       null: false, foreign_key: true
      t.jsonb       :metadata,   default: {}

      t.timestamps
    end
  end
end
