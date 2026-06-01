require "rails_helper"

RSpec.describe "Shops API", type: :request do
  let(:api_key) { create(:api_key, key: "test-api-key") }

  let(:headers) { { "X-API-Key" => api_key.key } }

  describe "POST /api/v1/shops/register" do
    # it "returns a successful response" do
    #   post "/api/v1/shops/register", params: { shop: {
    #     name: "Test Shop",
    #     email: "test@example.com",
    #     password: "password"
    #   }}, headers: headers
    #   expect(response).to have_http_status(:success)
    # end

    it "creates a new shop returns a successful response" do
      expect {
        post "/api/v1/shops/register", params: { shop: {
          name: "Test Shop",
          email: "test@example.com",
          password: "password"
        } }, headers: headers
      }.to change(Shop, :count).by(1)
      expect(response).to have_http_status(:success)
    end

    it "returns an error when shop already exists" do
      create(:shop, email: "test@example.com")
      post "/api/v1/shops/register", params: { shop: {
        name: "Test Shop",
        email: "test@example.com",
        password: "password"
      } }, headers: headers
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include("Shop already exists")
    end
  end
end
