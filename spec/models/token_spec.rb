require 'rails_helper'

RSpec.describe Token, type: :model do
  subject { build(:token) }

  describe "validations" do
    it { should validate_presence_of(:public_key) }
    it { should validate_uniqueness_of(:public_key) }
    it { should validate_presence_of(:private_key) }
    it { should validate_uniqueness_of(:private_key) }
  end

  describe "associations" do
    it { should belong_to(:shop) }
  end
end
