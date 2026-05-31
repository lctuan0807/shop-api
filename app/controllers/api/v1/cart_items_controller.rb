module Api
  module V1
    class CartItemsController < ApplicationController
      def create
        item = Carts::AddItemService.new(current_user, cart_item_params).call

        render_success(
          "Item added to cart",
          {
            cart_item: CartItemSerializer.new(item)
          }
        )
      end

      def update
        item = Carts::UpdateItemService.new(cart_item, cart_item_params).call

        render_success(
          "Item updated",
          {
            cart_item: CartItemSerializer.new(item)
          }
        )
      end

      def destroy
        cart_item.destroy!

        render_success(
          "Cart item removed",
          {
            cart_item: CartItemSerializer.new(cart_item)
          }
        )
      end

      private

      def cart_item
        @cart_item ||= current_user.cart.items.find(params[:id])
      end

      def current_user
        @current_user ||= User.first
      end

      def cart_item_params
        params.permit(:product_id, :quantity, :old_quantity)
      end
    end
  end
end
