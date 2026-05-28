class Product < ApplicationRecord
  belongs_to :shop

  CATEGORIES = %w[
    clothing
    electronic
  ].freeze

  validates :name, presence: true
  validates :thumbnail, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end
