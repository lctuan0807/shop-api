class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :thumbnail, :description, :price, :quantity, :category, :metadata, :variations, :is_published, :is_draft
end
