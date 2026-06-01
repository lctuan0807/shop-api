module Discounts
  class UpdateService
    include DiscountServiceConcern

    def initialize(discount, params)
      @discount = discount
      @params = params
    end

    def call
      validate_dates!
      validate_products!

      ActiveRecord::Base.transaction do
        update_discount!
        update_products!
      end

      @discount
    end

    private

    attr_reader :discount, :params

    def update_discount!
      discount.update!(discount_attributes)
    end

    def update_products!
      return unless params.key?(:product_ids)

      discount.products = products
    end

    def products
      @products ||= discount.shop.products.where(id: product_ids)
    end
  end
end
