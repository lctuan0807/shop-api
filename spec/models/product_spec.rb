require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:thumbnail) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:category) }
    it { should validate_inclusion_of(:category).in_array(Product::CATEGORIES) }
  end

  describe 'associations' do
    it { should belong_to(:shop) }
  end
end
