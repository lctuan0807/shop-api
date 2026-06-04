module Discounts
  class ShopDiscountCalculator
    def initialize(shop_data)
      @shop_data = shop_data
    end

    def call
      discounts.sum do |discount|
        calculate_discount(discount)
      end
    end

    private

    attr_reader :shop_data

    def discounts
      @discounts ||= Discount.where(
        id: discount_ids,
        shop_id: shop_id
      )
    end

    def discount_ids
      shop_data[:discount_ids] || []
    end

    def shop_id
      shop_data[:shop_id]
    end
  end
end
