class InventorySerializer < ActiveModel::Serializer
  attributes :id, :stock, :product_id
end
