module Checkouts
  class DiscountService
    def initialize(discount_ids, total_price)
      @discount_ids = discount_ids
      @total_price = total_price
    end

    def call
      discounts.sum do |discount|
        case discount.kind
        when "percentage"
          (
            @total_price *
            discount.value /
            100
          )

        when "fixed"
          discount.value
        else
          0
        end
      end
    end

    private

    def discounts
      Discount.where(
        id: @discount_ids
      )
    end
  end
end
