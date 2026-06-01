module Inventories
  class AddStockService
    def initialize(shop, params)
      @shop = shop
      @params = params
    end

    def call
      inventory.with_lock do
        inventory.stock += stock
        inventory.save!
      end

      inventory
    end

    private

    attr_reader :shop, :params

    def inventory
      @inventory ||= Inventory.find_or_create_by!(shop: shop, product_id: product_id)
    end

    def product_id
      @params[:product_id]
    end

    def stock
      @params[:stock]
    end
  end
end
