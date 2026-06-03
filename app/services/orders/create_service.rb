module Orders
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
      @locks = []
    end

    def call
      acquire_locks!
  
      ActiveRecord::Base.transaction do
          lock_inventory_rows!

          validate_inventory!

          order = create_order!

          create_order_items!(order)

          deduct_inventory!

          order
        end
      ensure
        release_inventory_locks!
      end
    end
    
    private

    attr_reader :user, :params, :locks

    def create_order!
      Order.create!(
        user: user,
        total_price: total_price,
        total_discount: total_discount,
        shipping_fee: shipping_fee,
        total_checkout: total_checkout,
        status: :pending
      )
    end

    def create_order_items!(order)
      requested_products.each do |item|
        product = product_map[item[:product_id]]

        OrderItem.create!(
          order: order,
          product: product,
          quantity: item[:quantity],
          price: product.price
        )
      end
    end

    def deduct_inventory!
      inventories.each do |inventory|
        quantity = requested_quantities[inventory.product_id]

        inventory.update!(stock: inventory.stock - quantity)
      end
    end

    def product_map
      @product_map ||= Product.where(id: requested_product_ids).index_by(&:id)
    end

    def requested_products
      @requested_products ||= params[:shops].flat_map { |shop| shop[:products] }
    end

    def requested_product_ids
      requested_products.map { |item| item[:product_id] }
    end

    def requested_quantities
      @requested_quantities ||= requested_products.each_with_object({}) do |item, hash|
        hash[item[:product_id]] = item[:quantity]
      end
    end

    def lock_inventory_rows!
      Inventory.where(id: inventory_ids).order(:id).lock.load
    end

    def validate_inventory!
      inventories.each do |inventory|
        quantity = requested_quantities[inventory.product_id]

        raise BadRequestError, "Insufficient stock for product #{inventory.product_id}" if inventory.stock < quantity
      end
    end

    def inventories
      @inventories ||= Inventory.includes(:product).where(product_id: requested_product_ids)
    end

    def inventory_ids
      inventories.pluck(:id)
    end

    # lock inventories in sorted order to avoid deadlocks
    def acquire_locks!
      inventory_ids.sort.each do |inventory_id|
        lock = RedisLock.new("inventory:#{inventory_id}")
        lock.acquire!
        locks << lock
      end
    end

    def release_inventory_locks!
      locks.reverse_each(&:release!)
    end
  end
end
