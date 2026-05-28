class Product < ApplicationRecord
  extend FriendlyId
  
  friendly_id :name, use: :slugged

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
