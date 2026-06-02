FactoryBot.define do
  factory :comment do
    product { nil }
    user_id { 1 }
    content { "MyString" }
    lft { 1 }
    rgt { 1 }
    parent_id { 1 }
  end
end
