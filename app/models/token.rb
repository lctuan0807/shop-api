class Token < ApplicationRecord
  belongs_to :shop, foreign_key: "user_id"

  validates :public_key, presence: true, uniqueness: true
  validates :private_key, presence: true, uniqueness: true
end
