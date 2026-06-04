module Orders
  class InventoryDeductService
    def initialize(checkout_params)
      @checkout_params = checkout_params
    end

    def call
      inventories.each do |inventory|
        inventory.update!(
          stock: inventory.stock - quantity_map[inventory.product_id]
        )
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
