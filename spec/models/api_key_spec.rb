require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  subject { build(:api_key) }

  describe "validations" do
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
    it { should validate_presence_of(:permissions) }
  end

  describe "permissions validation" do
    it "validates permissions" do
      api_key = ApiKey.new(key: "test", permissions: [ "read", "write", "admin" ])
      expect(api_key).to be_valid
    end

    it "invalidates invalid permissions" do
      api_key = ApiKey.new(key: "test", permissions: [ "read", "write", "invalid" ])
      expect(api_key).not_to be_valid
      expect(api_key.errors[:permissions]).to include("contains invalid permissions: invalid")
    end
  end
end
