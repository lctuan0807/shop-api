module Api
  module V1
    class ShopsController < ApplicationController
      # POST /register
      def register
        shop, tokens = ShopCreator.new(shop_params).call

        if shop
          render_success(
            "Shop created successfully",
            {
              shop: ShopSerializer.new(shop),
              token: tokens
            },
            status: :created
          )
        else
          render json: shop.errors, status: :unprocessable_content
        end
      end

      # POST /login
      def login
        shop, tokens = ShopAuthenticator.new({
          email: params[:email],
          password: params[:password]
        }).call

        if shop
          render_success(
            "Shop logged in successfully",
            {
              shop: ShopSerializer.new(shop),
              token: tokens
            }
          )
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def shop_params
        params.require(:shop).permit(:name, :email, :password, :status, :verify, :roles)
      end
    end
  end
end
