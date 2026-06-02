class Comment < ApplicationRecord
  acts_as_nested_set

  belongs_to :product
end
