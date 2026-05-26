class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :thumbnail, :description, :price, :quantity, :category, :metadata
end
