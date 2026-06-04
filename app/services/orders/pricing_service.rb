module Orders
  class PricingService
    def initialize(checkout_params)
      @checkout_params = checkout_params
    end

    def call
      {
        total_price: total_price,
        shipping_fee: shipping_fee,
        total_discount: total_discount,
        total_checkout: total_price + shipping_fee - total_discount
      }
    end

    private

    attr_reader :checkout_params

    def total_price
      @total_price ||= begin
        requested_products.sum do |item|
          product = products[item[:product_id]]

          product.price * item[:quantity]
        end
      end
    end

    def shipping_fee
      Checkouts::ShippingFeeService.new(checkout_params[:shops].first[:shop_id], total_price).call
    end

    def total_discount
      Discounts::CalculateService.new(checkout_params[:shops]).call
    end

    def products
      @products ||= Product.where(id: requested_products.map { _1[:product_id] }).index_by(&:id)
    end

    def requested_products
      checkout_params[:shops].flat_map { |shop| shop[:products] }
    end
  end
end
