class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :thumbnail, :description, :price, :quantity, :category, :metadata, :is_published, :is_draft
end
