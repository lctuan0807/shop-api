module Api
  module V1
    class ProductsController < ApplicationController
      # skip_before_action :authenticate!, only: [:index, :show]

      def create
        product = Product.create!(product_params)

        if product
          render_success(
            "Product created successfully",
            {
              product: ProductSerializer.new(product)
            },
            status: :created
          )
        else
          render_error(
            code: "ERROR",
            message: "Failed to create product",
            status: :unprocessable_entity,
            details: product.errors.to_hash
          )
        end
      end

      
      private

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:name, :thumbnail, :description, :price, :quantity, :category, :shop_id, metadata: {})
      end
    end
  end
end
