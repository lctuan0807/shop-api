module Orders
  class InventoryValidator
    def initialize(checkout_params)
      @checkout_params = checkout_params
    end

    def call
      inventories.lock.each do |inventory|
        requested = quantity_map[inventory.product_id]

        raise BadRequestError, "Insufficient stock for product #{inventory.product_id}" if inventory.stock < requested
      end
    end

    private

    attr_reader :checkout_params

    def inventories
      Inventory.where(product_id: quantity_map.keys)
    end

    def quantity_map
      @quantity_map ||=
        checkout_params[:shops]
          .flat_map { |shop| shop[:products] }
          .each_with_object({}) { |product, hash| hash[product[:product_id]] = product[:quantity] }
    end
  end
end