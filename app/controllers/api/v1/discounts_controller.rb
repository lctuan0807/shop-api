module Api
  module V1
    class DiscountsController < ApplicationController
      def create
        discount = Discounts::CreateService.new(shop_id, discount_params).call

        render_success(
          'Discount created successfully',
          {
            discount: DiscountSerializer.new(discount)
          }
        )
      end

      private

      def discount_params
        params.require(:discount).permit(:name, :description, :kind, :value, :code, :start_date, :end_date, :max_uses, :max_uses_per_user, :min_order_value, :max_order_value, :applies_to, :product_ids, :is_active)
      end
    end
  end
end
