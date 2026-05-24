module Api
  module V1
    class ShopsController < ApplicationController
      before_action :set_shop, only: %i[ show update destroy ]

      rescue_from ShopAlreadyExists, with: :render_shop_already_exists

      # GET /shops
      def index
        @shops = Shop.all

        render json: @shops
      end

      # GET /shops/1
      def show
        render json: @shop
      end

      # POST /shops
      def create
        shop, tokens = ShopCreator.new(shop_params).call

        if shop
          # render json: {
          #   metadata: {
          #     shop: shop,
          #     token: tokens
          #   }
          # }, status: :created

          render json: shop,
                serializer: RegisterShopSerializer,
                tokens: tokens,
                status: :created
        else
          render json: shop.errors, status: :unprocessable_content
        end
      end

      # PATCH/PUT /shops/1
      def update
        if @shop.update(shop_params)
          render json: @shop
        else
          render json: @shop.errors, status: :unprocessable_content
        end
      end

      # DELETE /shops/1
      def destroy
        @shop.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_shop
          @shop = Shop.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def shop_params
          params.require(:shop).permit(:name, :email, :password, :status, :verify, :roles)
        end

        def render_shop_already_exists
          render json: {
            code: 409,
            error: "Shop already exists"
          }, status: :conflict
        end
    end
  end
end
