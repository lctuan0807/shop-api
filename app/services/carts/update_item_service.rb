module Carts
  class UpdateItemService
    def initialize(cart_item, params)
      @cart_item = cart_item
      @params = params
    end

    def call
      validate_old_quantity!

      cart_item.update!(quantity: params[:quantity])

      cart_item
    end

    private

    attr_reader :cart_item, :params

    def validate_old_quantity!
      return unless params[:old_quantity]

      return if cart_item.quantity == params[:old_quantity]

      raise BadRequestError, "Cart item changed"
    end
  end
end
