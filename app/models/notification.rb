class Notification < ApplicationRecord
  enum :kind, { product_created: "Product Created", product_updated: "Product Updated", promotion_created: "Promotion Created" }

  belongs_to :sender, polymorphic: true
  # belongs_to :receiver, polymorphic: true
  
  validates :kind, presence: true
  validates :sender_id, presence: true
  validates :sender_type, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true

  scope :by_user, ->(user_id) { where(receiver_id: user_id) }
  scope :by_kind, ->(kind) { where(kind: kind) }
end
