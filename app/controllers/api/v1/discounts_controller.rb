module Api
  module V1
    class DiscountsController < ApplicationController
      def create
        discount = Discounts::CreateService.new(current_shop, discount_params).call

        render_success(
          "Discount created successfully",
          {
            discount: DiscountSerializer.new(discount)
          },
          status: :created
        )
      end

      def update
        Discounts::UpdateService.new(discount, discount_params).call

        render_success(
          "Discount updated successfully",
          {
            discount: DiscountSerializer.new(discount.reload)
          },
          status: :ok
        )
      end

      def amount
        result = Discounts::AmountService.new(current_shop, params).call

        render_success(
          "Success code found",
          result
        )
      end

      private

      def discount
        @discount ||= current_shop.discounts.find(params[:id])
      end

      def discount_params
        params.require(:discount).permit(:name, :description, :kind, :value, :code, :start_date, :end_date, :max_uses,
          :max_uses_per_user, :min_order_value, :max_order_value, :applies_to, :is_active, product_ids: [])
      end
    end
  end
end
