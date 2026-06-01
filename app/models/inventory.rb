class Inventory < ApplicationRecord
  belongs_to :product
  belongs_to :shop
  has_many :reservations

  validates :stock, numericality: { greater_than_or_equal_to: 0 }
end

