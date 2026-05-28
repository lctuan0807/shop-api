require "rails_helper"

RSpec.describe ShopCreator do
  subject { described_class.new(name: "Test Shop", email: "test@example.com", password: "password") }

  describe "#call" do
    context "creates a new shop" do
      before do
        expect(TokenService).to receive(:issue_token).and_return({ access_token: "access_token", refresh_token: "refresh_token" })
        expect(TokenService).to receive(:create_or_update_token)
      end

      it "creates a new shop" do
        expect {
          subject.call
        }.to change(Shop, :count).by(1)
      end
    end

    context "returns an error when shop already exists" do
      before do
        create(:shop, email: "test@example.com")
      end

      it "raises an error" do
        expect {
          subject.call
        }.to raise_error(BadRequestError, "Shop already exists")
      end
    end
  end
end
