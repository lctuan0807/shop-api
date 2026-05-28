require 'rails_helper'

RSpec.describe Shop, type: :model do
  subject(:shop) { build(:shop) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'associations' do
    it { should have_many(:products) }
  end
end
