class CommentSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :user_id, :content, :lft, :rgt, :parent_id, :depth, :children_count
end
