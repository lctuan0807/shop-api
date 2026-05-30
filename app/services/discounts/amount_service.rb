module Discounts
  class AmountService
    def initialize(shop, params)
      @shop = shop
      @params = params
    end

    def call
      validate_discount!

      {
        original_amount: original_amount,
        discount_amount: discount_amount,
        final_amount: final_amount,
        discount_code: discount.code
      }
    end

    private

    attr_reader :shop, :params
    
    def discount
      @discount ||= shop.discounts.find_by(code: params[:code])
    end

    def products
      @products ||= shop.products.where(id: product_ids)
    end

    def items
      params[:items] || []
    end

    def product_ids
      items.map { |item| item[:product_id] }
    end

    def expired?
      return false unless discount.end_date

      Time.current > discount.end_date
    end

    def usage_exceeded?
      return false unless discount.max_uses

      discount.uses_count >= discount.max_uses
    end

    def validate_discount!
      raise NotFoundError, "Discount not found" unless discount

      raise BadRequestError, "Discount inactive" unless discount.is_active?

      raise BadRequestError, "Discount expired" if expired?

      raise BadRequestError, "Discount usage exceeded" if usage_exceeded?
    end

    def original_amount
      @original_amount ||=
        products.sum do |product|
          item = items.find { |item| item[:product_id].to_i == product.id }
          product.price * item[:quantity].to_i
        end
    end

    def discount_amount
      discount.kind == "fixed" ? discount.value : original_amount * discount.value / 100.0
    end

    def final_amount
      original_amount - discount_amount
    end
  end
end
