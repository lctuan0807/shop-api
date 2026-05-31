module Carts
  class AddItemService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      item.quantity = item.quantity.to_i + quantity
      item.save!
      item
    end

    private

    attr_reader :user, :params

    def item
      @item ||= cart.items.find_or_initialize_by(
        product_id: params[:product_id]
      )
    end

    def cart
      @cart ||= user.cart || user.create_cart!
    end

    def quantity
      params[:quantity].to_i
    end
  end
end
