module Api
  module V1
    class InventoriesController < ApplicationController
      def create
        inventory = Inventories::AddStockService.new(current_shop, inventory_params).call

        render_success(
          "Stock added successfully",
          { 
            inventory: InventorySerializer.new(inventory)
          }
        )
      end

      private

      def inventory_params
        params.require(:inventory).permit(
          :product_id,
          :stock
        )
      end
    end
  end
end
