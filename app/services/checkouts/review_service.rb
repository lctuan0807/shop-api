module Checkouts
  class ReviewService
    def initialize(params)
      @params = params
    end

    def call
      shop_results = shops.map do |shop_data|
        build_shop_checkout(shop_data)
      end

      {
        shops: shop_results,
        summary: summary(shop_results)
      }
    end

    private

    attr_reader :params

    def shops
      params[:shops] || []
    end

    def build_shop_checkout(shop_data)
      total_price = calculate_total_price(shop_data)
      shipping_fee = calculate_shipping_fee(shop_data[:shop_id], total_price)
      discount_amount = calculate_discount(shop_data[:discount_ids], total_price)

      {
        shop_id: shop_data[:shop_id],
        total_price: total_price,
        shipping_fee: shipping_fee,
        discount_amount: discount_amount,
        total_checkout: total_price + shipping_fee - discount_amount
      }
    end

    def calculate_total_price(shop_data)
      products = shop_data[:products] || []

      products.sum { |product| product[:price].to_i * product[:quantity].to_i }
    end

    def calculate_shipping_fee(shop_id, total_price)
      Checkouts::ShippingFeeService.new(shop_id, total_price).call
    end

    def calculate_discount(discount_ids, total_price)
      Checkouts::DiscountService.new(discount_ids, total_price).call
    end

    def summary(shop_results)
      {
        total_price: shop_results.sum { _1[:total_price] },
        total_shipping_fee: shop_results.sum { _1[:shipping_fee] },
        total_discount: shop_results.sum { _1[:discount_amount] },
        total_checkout: shop_results.sum { _1[:total_checkout] }
      }
    end
  end
end
