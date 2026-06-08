class Product < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model

  friendly_id :name, use: :slugged

  belongs_to :shop

  has_many :discount_products, dependent: :destroy
  has_many :discounts, through: :discount_products
  has_many :comments, dependent: :destroy
  has_one :inventory, dependent: :destroy

  has_one_attached :thumbnail

  CATEGORIES = %w[
    clothing
    electronic
  ].freeze

  validates :name, presence: true
  validates :thumbnail, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  scope :published, -> { where(is_published: true) }

  pg_search_scope :search,
    against: [ :name, :description ],
    using: {
      tsearch: { prefix: true }
    }
end
