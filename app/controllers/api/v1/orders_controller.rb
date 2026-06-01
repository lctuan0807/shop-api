module Api
  module V1
    class OrdersController < ApplicationController
      def create
        order = Orders::CreateService.new(
          current_user,
          order_params
        ).call

        render_success(
          "Order created successfully",
          {
            order: OrderSerializer.new(order)
          },
          status: :created
        )
      end
    end
  end
end
