module Checkouts
  class ShippingFeeService
    FREE_SHIPPING_THRESHOLD = 500000
    DEFAULT_FEE = 37000

    def initialize(shop_id, total_price)
      @shop_id = shop_id
      @total_price = total_price
    end

    def call
      return 0 if @total_price >= FREE_SHIPPING_THRESHOLD

      DEFAULT_FEE
    end
  end
end
