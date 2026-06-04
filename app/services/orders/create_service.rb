module Orders
  class CreateService
    def initialize(user, checkout_params)
      @user = user
      @checkout_params = checkout_params
    end

    def call
      lock_manager.acquire!

      ActiveRecord::Base.transaction do
        Orders::InventoryValidator.new(checkout_params).call

        pricing = Orders::PricingService.new(checkout_params).call

        order = create_order!(pricing)

        Orders::OrderItemCreator.new(order, checkout_params).call

        Orders::InventoryDeductService.new(checkout_params).call

        order
      end
    ensure
      lock_manager.release!
    end

    private

    attr_reader :user, :checkout_params

    def create_order!(pricing)
      Order.create!(
        user: user,
        total_price: pricing[:total_price],
        shipping_fee: pricing[:shipping_fee],
        total_discount: pricing[:total_discount],
        total_checkout: pricing[:total_checkout],
        status: :pending
      )
    end

    def lock_manager
      @lock_manager ||= Locks::InventoryLockManager.new(product_ids)
    end

    def product_ids
      checkout_params[:shops]
        .flat_map { |shop| shop[:products] }
        .map { |product| product[:product_id] }
    end
  end
end
