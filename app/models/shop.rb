class Shop < ApplicationRecord
  has_secure_password

  has_many :products, dependent: :destroy

  enum :roles, { shop: 0, writer: 1, editor: 2, admin: 3 }, default: [ :shop ]

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
