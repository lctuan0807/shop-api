class DiscountSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :kind, :value, :code, :start_date, :end_date, :max_uses, :max_uses_per_user, :min_order_value, :max_order_value, :applies_to, :product_ids, :is_active
end
