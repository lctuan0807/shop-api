module Orders
  class CreateService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      lock_key = "checkout:user:#{user.id}"
      lock = RedisLock.new(lock_key)
      lock.acquire
    end
  end
end
