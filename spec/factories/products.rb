FactoryBot.define do
  factory :product do
    name { "Test Product" }
    thumbnail { "https://example.com/test.jpg" }
    price { 100.0 }
    quantity { 10 }
    category { "clothing" }
  end
end
