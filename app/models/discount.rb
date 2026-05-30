class Discount < ApplicationRecord
  belongs_to :shop

  validates :name, presence: true
  validates :description, presence: true
  validates :kind, presence: true
  validates :value, presence: true
  validates :code, presence: true, uniqueness: { scope: :shop_id }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :max_uses, presence: true
  validates :max_uses_per_user, presence: true
  validates :min_order_value, presence: true
  validates :applies_to, presence: true

  validate :validate_date_range
  validate :validate_end_date_not_in_past
  
  enum :kind, { fixed: 'fixed', percentage: 'percentage' }
  enum :applies_to, { all_products: 'all_products', specific_products: 'specific_products' }
  
  scope :active, -> { where(is_active: true) }
  scope :valid, -> { where('start_date <= ? AND end_date >= ?', Time.current, Time.current) }

  private

  def validate_date_range
    return if start_date.blank? || end_date.blank?
    
    errors.add(:end_date, 'must be after start date') if end_date <= start_date
  end

  def validate_end_date_not_in_past
    return if end_date.blank?

    errors.add(:end_date, 'must be in the future') if end_date < Date.today
  end
end
