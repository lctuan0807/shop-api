FactoryBot.define do
  factory :api_key do
    key { SecureRandom.hex(64) }
    permissions { ["read"] }
    status { true }
  end
end
