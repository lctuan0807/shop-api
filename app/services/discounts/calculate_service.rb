module Discounts
  class CalculateService
    def initialize(shops)
      @shops = shops
    end

    def call
      shops.sum do |shop_data|
        ShopDiscountCalculator.new(
          shop_data
        ).call
      end
    end

    private

    attr_reader :shops
  end
end
