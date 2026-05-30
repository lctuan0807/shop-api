module Discounts
  class CreateService
    include DiscountServiceConcern

    def initialize(shop, params)
      @shop = shop
      @params = params
    end

    def call
      validate_dates!
      validate_products!

      ActiveRecord::Base.transaction do
        discount = create_discount!
        attach_products!(discount)

        discount
      end
    end

    private

    attr_reader :shop, :params

    def create_discount!
      shop.discounts.create!(
        discount_attributes
      )
    end

    def attach_products!(discount)
      return if product_ids.blank?

      discount.products << products
    end

    def products
      @products ||= shop.products.where(id: product_ids)
    end
  end
end
