module Api
  module V1
    class CartsController < ApplicationController
      def show
        # @cart = Cart.find_by(user_id: current_user.id)
        cart = Cart.first

        render_success(
          message: "Cart retrieved successfully",
          metadata: {
            cart: CartSerializer.new(cart)
          }
        )
      end
    end
  end
end
