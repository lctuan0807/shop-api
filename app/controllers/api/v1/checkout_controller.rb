module Api
  module V1
    class CheckoutController < ApplicationController
      def review
        result = Checkouts::ReviewService.new(checkout_params).call

        render_success(
          "Checkout reviewed successfully",
          result
        )
      end

      private

      def checkout_params
        params.require(:checkout).permit(
          :user_id,
          shops: [
            :shop_id,
            discount_ids: [],
            products: [:id, :price, :quantity]
          ]
        )
      end
    end
  end
end
