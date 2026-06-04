module Locks
  class InventoryLockManager
    def initialize(product_ids)
      @product_ids = product_ids.sort
      @locks = []
    end

    def acquire!
      inventory_ids.each do |inventory_id|
        lock = RedisLock.new("inventory:#{inventory_id}")
        lock.acquire!
        @locks << lock
      end
    end

    def release!
      @locks.reverse_each(&:release!)
    end

    private

    def inventory_ids
      @inventory_ids ||= Inventory.where(product_id: @product_ids).pluck(:id).sort
    end
  end
end
