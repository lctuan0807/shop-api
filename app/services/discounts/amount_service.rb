module Discounts
  class AmountService
    def initialize(code, user_id, shop_id, products)
      @code = code
      @user_id = user_id
      @shop_id = shop_id
      @products = products
    end

    def call
      discount

      raise NotFoundError, "Discount not found" if @discount.nil?
      raise NotFoundError, "Discount is not active" if !@discount.is_active
      raise NotFoundError, "Discount is expired" if @discount.end_date < Time.current
      raise NotFoundError, "Discount is not available" unless @discount.max_uses

      @total_order = total_order

      raise NotFoundError, "Discount requires a minimum order value of #{discount.min_order_value}" if @total_order < discount.min_order_value

      @discount_amount = calculate_discount
      
      {
        total_order: @total_order,
        discount_amount: @discount_amount,
        total_price: @total_order - @discount_amount
      }
    end

    private

    def calculate_discount
      discount.kind == 'fixed' ? discount.value : @total_order * discount.value / 100
    end

    def total_order
      return 0 if discount.min_order_value <= 0

      @products.inject(0) { |sum, product| sum + product[:price] * product[:quantity] }
    end

    def discount
      @discount ||= Discount.find_by(code: @code, shop_id: @shop_id)
    end
  end
end
