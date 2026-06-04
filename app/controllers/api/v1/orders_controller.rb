module Api
  module V1
    class OrdersController < ApplicationController
      def create
        order = Orders::CreateService.new(User.first, order_params).call

        render_success(
          "Order created successfully",
          {
            order: OrderSerializer.new(order)
          },
          status: :created
        )
      end

      private

      def order_params
        params.require(:checkout).permit(
          shops: [
            :shop_id,
            {
              discount_ids: [],
              products: [
                :product_id,
                :quantity
              ]
            }
          ]
        )
      end
    end
  end
end
