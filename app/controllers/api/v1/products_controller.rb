module Api
  module V1
    class ProductsController < ApplicationController
      # skip_before_action :authenticate!, only: [:index, :show]

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
      
      private

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:name, :thumbnail, :description, :price, :quantity, :category, :shop_id, metadata: {})
      end
    end
  end
end
