module Orders
  class OrderItemCreator
    def initialize(order, checkout_params)
      @order = order
      @checkout_params = checkout_params
    end

    def call
      products.each do |item|
        product = product_map[item[:product_id]]

        OrderItem.create!(
          order: order,
          product: product,
          quantity: item[:quantity],
          price: product.price
        )
      end
    end

    private

    attr_reader :order, :checkout_params

    def products
      checkout_params[:shops].flat_map { |shop| shop[:products] }
    end

    def product_map
      @product_map ||= Product.where(id: products.map { _1[:product_id] }).index_by(&:id)
    end
  end
end
