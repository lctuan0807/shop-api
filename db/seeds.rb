# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

10.times.each do |i|
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price,
    shop_id: 14,
    quantity: Faker::Number.between(from: 1, to: 100),
    category: "electronic",
    thumbnail: Faker::Internet.url,
    metadata: {
      manufacturer: Faker::Company.name,
      model: Faker::Commerce.product_name,
      color: Faker::Commerce.color
    },
    is_published: true,
    is_draft: false,
    average_rating: Faker::Number.between(from: 1, to: 5),
    variations: {
      color: Faker::Commerce.color
    }
  )
end


10.times.each do |i|
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price,
    shop_id: 14,
    quantity: Faker::Number.between(from: 1, to: 100),
    category: "clothing",
    thumbnail: Faker::Internet.url,
    metadata: {
      brand: Faker::Company.name,
      size: [ "S", "M", "L", "XL" ].sample,
      material: Faker::Commerce.material
    },
    is_published: true,
    is_draft: false,
    average_rating: Faker::Number.between(from: 1, to: 5),
    variations: {}
  )
end
