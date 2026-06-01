FactoryBot.define do
  factory :shop do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
