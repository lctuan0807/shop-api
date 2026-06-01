class Cart < ApplicationRecord
  # belongs_to :user
  has_many :items, dependent: :destroy, class_name: "CartItem"
  has_many :products, through: :items
end
