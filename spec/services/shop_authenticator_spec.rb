require 'rails_helper'

RSpec.describe ShopAuthenticator do
  subject { described_class.new({ email: "test@example.com", password: "password" }) }

  let!(:shop) { create(:shop, email: "test@example.com", password: "password", password_confirmation: "password") }

  describe "#call" do
    context "when shop exists and password is correct" do
      before do
        allow(TokenService).to receive(:issue_token).and_return({ access_token: "access_token", refresh_token: "refresh_token" })
        allow(TokenService).to receive(:create_or_update_token)
      end

      it "returns the shop and tokens" do
        result = subject.call
        expect(result).to eq([ shop, { access_token: "access_token", refresh_token: "refresh_token" } ])
      end
    end

    context "when shop does not exist" do
      before do
        allow(Shop).to receive(:find_by).and_return(nil)
      end

      it "raises an error" do
        expect {
          subject.call
        }.to raise_error(BadRequestError, "Shop not registered")
      end
    end

    context "when password is incorrect" do
      before do
        allow(Shop).to receive(:find_by).and_return(shop)
        allow(shop).to receive(:authenticate).and_return(false)
      end

      it "raises an error" do
        expect {
          subject.call
        }.to raise_error(UnauthorizedError, "Invalid credentials")
      end
    end
  end
end
