module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authenticate!, only: [:index, :show]

      def index
        products = Products::AllQuery.new.call(params)
        
        render_success(
          "Products retrieved successfully",
          {
            products: serialize_collection(products, serializer: ProductSerializer)
          }
        )
      end

      def show
        product = Product.friendly.find(params[:id])
        
        render_success(
          "Product retrieved successfully",
          {
            product: ProductSerializer.new(product)
          }
        )
      end

      def create
        creator = Products::Factory.build(
          product_params[:category]
        )
        product = creator.create(product_params.merge!(shop_id: @token.user_id))

        render_success(
          "Product created successfully",
          {
            product: ProductSerializer.new(product)
          },
          status: :created
        )
      end

      def draft
        products = Product.where(shop_id: @token.user_id, is_draft: true).limit(50).order(created_at: :desc)

        render_success(
          "Products retrieved successfully",
          {
            products: serialize_collection(products, serializer: ProductSerializer)
          }
        )
      end

      def published
        products = Product.where(shop_id: @token.user_id, is_published: true).limit(50).order(created_at: :desc)

        render_success(
          "Products retrieved successfully",
          {
            products: serialize_collection(products, serializer: ProductSerializer)
          }
        )
      end

      def publish
        product = Product.friendly.find(params[:id])
        product.update!(is_published: true, is_draft: false)

        render_success(
          "Product published successfully",
          {
            product: ProductSerializer.new(product)
          }
        )
      end

      def unpublish
        product = Product.friendly.find(params[:id])
        product.update!(is_published: false, is_draft: true)

        render_success(
          "Product unpublished successfully",
          {
            product: ProductSerializer.new(product)
          }
        )
      end
      
      private

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:name, :thumbnail, :description, :price, :quantity, :category, :shop_id, metadata: {}, variations: {})
      end
    end
  end
end
