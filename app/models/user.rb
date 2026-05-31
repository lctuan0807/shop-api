class User < ApplicationRecord
  has_secure_password

  has_one :cart, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
