FactoryBot.define do
  factory :notification do
    kind { "MyString" }
    sender_id { 1 }
    receiver_id { 1 }
    content { "MyString" }
    options { "" }
  end
end
